# frozen_string_literal: true

# https://www.rubydoc.info/github/heartcombo/devise/master/ActionDispatch/Routing/Mapper%3Adevise_for
devise_for :users, path: '',
                   controllers: {
                     passwords: 'users/passwords',
                     registrations: 'users/registrations',
                     sessions: 'users/sessions'
                   },
                   path_names: {
                     sign_in: 'login',
                     sign_out: 'logout',
                     password: 'secret',
                     confirmation: 'verify',
                     unlock: 'unlock',
                     sign_up: 'register'
                   }

require 'sidekiq/web'
authenticate :user, ->(u) { u.admin? } do
  mount Sidekiq::Web, at: :sidekiq
  mount PgHero::Engine, at: :pghero
  # mount ExceptionTrack::Engine, at: "exception-track"
end

# resources :users, only: %i[index edit update] do
#   get :profile
# end

get :dashboard, to: 'dashboard#index'
