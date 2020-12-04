# frozen_string_literal: true

# 使用 Rails.application.credentials 前需要引入环境
require File.expand_path('./environment', __dir__)

lock '~> 3.14.1'

set :application, '<app_name>'
set :deploy_to,   "/var/www/#{fetch(:application)}"
set :deploy_via,  :remote_cache

# git
set :repo_url, '<your_repository_url>'
# ask :branch,   `git rev-parse --abbrev-ref HEAD`.chomp

# 交互式命令行（当 pty: true 时，有一个已知的错误会阻止 sidekiq 启动）
set :pty, false

# 部署设置
# set :user,    '<server_username>'
# set :tmp_dir, "/home/#{fetch :user}"
set :use_sudo, false

# rvm
set :rvm_type, :system
# set :rvm_custom_path, '/usr/local/rvm'

# ruby
set :rvm_ruby_version, '2.6.6'

# rails
set :stage,     :production
set :rails_env, :production

# puma
set :puma_bind,               "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}.sock"
set :puma_state,              "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,                "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log,         "#{release_path}/log/puma.error.log"
set :puma_error_log,          "#{release_path}/log/puma.access.log"
# set :ssh_options,             { forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa.pub] }
set :puma_workers,            0
set :puma_threads,            [4, 16]
set :puma_preload_app,        true
set :puma_worker_timeout,     nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord
# fix error "Bad file descriptor - fstat(2) (Errno::EBADF)"  [参考链接](https://github.com/puma/puma/issues/1957#issuecomment-552540416)
set :puma_restart_command,    'bundle exec --keep-file-descriptors puma'

# nginx
# set :nginx_server_name,          '<your_domain_name>'
# set :nginx_sites_available_path, '/etc/nginx/sites-available'
# set :nginx_sites_enabled_path,   '/etc/nginx/sites-enabled'

# 环境
# set :format,    :airbrussh
set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto
set :keep_releases, 5
set :default_env, {
  'DATABAE_USERNAME' => Rails.application.credentials.dig(:database, :username),
  'DATABAE_PASSWORD' => Rails.application.credentials.dig(:database, :password)
}
# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for :linked_files and :linked_dirs are []
append :linked_files, 'config/database.yml', 'config/master.key', 'config/credentials/production.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public', 'vendor'

# 自定义任务
namespace :deploy do
  desc '确保本地 Git 与远程同步'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts '警告: 请使用 `git push` 提交本地修改后再部署。'
        exit
      end
    end
  end

  desc '本地编译后上传服务器'
  task :upload_compiled_assets do
    on roles(:app) do
      # 本地编译
      run_locally do
        # 参考源码 https://github.com/rails/webpacker/blob/master/lib/tasks/webpacker
        execute 'RAILS_ENV=production rails webpacker:clobber'
        execute 'RAILS_ENV=production rails webpacker:compile'
      end

      # 上传静态资源到共享目录
      upload! 'public/packs', "#{shared_path}/public", recursive: true
      [
        '404.html',
        '422.html',
        '500.html',
        'apple-touch-icon-precomposed.png',
        'apple-touch-icon.png',
        'favicon.ico',
        'robots.txt',
        'test.mp4'
      ].each { |file| upload! "public/#{file}", "#{shared_path}/public" }
    end
  end

  desc '上传自定义 Nginx 配置并重启服务'
  task :nginx do
    on roles(:app) do
      upload! 'config/nginx.conf', '/etc/nginx/conf.d/<app_name>.conf'
      execute 'nginx -s reload'
    end
  end

  # desc 'Run rake npm:install'
  # task :npm_install do
  #   on roles(:web) do
  #     within release_path do
  #       execute("cd #{release_path} && npm install")
  #     end
  #   end
  # end

  desc '上传共享文件'
  task :make_linked_files do
    on roles(:app) do
      fetch(:linked_files).each { |file| upload! file, "#{shared_path}/#{file}" }
    end
  end

  desc '清理部署日志'
  task :clear do
    on roles(:app) do
      run_locally do
        execute 'echo "" > log/capistrano.log'
      end
    end
  end

  desc '初次部署脚本'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc '重启应用'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc '重建数据库数据'
  task :preseed do
    on roles(:app) do
      execute "cd #{shared_path} && mkdir -p vendor/initializers && rm -rf vendor/initializers/*"
      upload! 'vendor/initializers', "#{shared_path}/vendor", recursive: true
      execute "ln -s #{shared_path}/vendor #{release_path}/vendor"
    end
  end

  before :starting,            :check_revision
  after :check_revision,       :clear
  before 'check:linked_files', :make_linked_files
  after  :updated,             :upload_compiled_assets
end

# 设置任务执行时机
before 'puma:start', 'deploy:nginx'

# 查看所有可用命令: cap -T
# 全新部署: cap production deploy
# nginx 修改: cap production deploy:nginx
# 上传文件: cap production deploy:make_linked_files
# 数据初始化准备: cap production deploy:preseed
# 数据初始化: cap production deploy:db:seed
