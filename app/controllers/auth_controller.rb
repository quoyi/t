# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    @user = User.from_omniauth(auth_hash)
    self.current_user = @user
  end

  def failure
    set_flash_message! :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def failed_strategy
    return request.get_header('omniauth.error.strategy') if request.respond_to?(:get_header)

    request.env['omniauth.error.strategy']
  end

  def failure_message
    exception = failure_exception
    error   = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error        if exception.respond_to?(:error)
    error ||= failure_type.to_s
    error&.to_s.try(:humanize)
  end

  def after_omniauth_failure_path_for(scope)
    new_session_path(scope)
  end

  def failure_exception
    request.respond_to?(:get_header) ? request.get_header('omniauth.error') : request.env['omniauth.error']
  end

  def failure_type
    request.respond_to?(:get_header) ? request.get_header('omniauth.error.type') : request.env['omniauth.error.type']
  end

  # def translation_scope
  #   'devise.omniauth_callbacks'
  # end
end
