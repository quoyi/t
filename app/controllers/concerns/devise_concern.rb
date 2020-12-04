# frozen_string_literal: true

module DeviseConcern
  extend ActiveSupport::Concern

  included do
    before_action :store_user_location!, if: :storable_location?
    before_action :devise_params_permit!, if: :devise_controller?
    before_action :authenticate_licence!

    helper_method :current_or_guest_user
  end

  protected

  def devise_params_permit!
    attribute_names = %i[login mobile email password password_confirmation current_password remember_me]
    devise_parameter_sanitizer.permit(:sign_in, keys: attribute_names)
    devise_parameter_sanitizer.permit(:sign_up, keys: attribute_names)
  end

  def authenticate_licence!
    return redirect_to(expired_url) unless unexpired?

    authenticate_user!
  end

  def current_or_guest_user
    return guest_user unless current_user

    if session[:guest_user_id] && session[:guest_user_id] != current_user.id
      # user_convertor
      # reload guest_user to prevent caching before destruction
      guest_user(false).try(:reload).try(:destroy)
      session[:guest_user_id] = nil
    end

    current_user
  end

  def guest_user(with_retry: true)
    @guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  private

  def after_sign_in_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    # return admin_root_path if resource_or_scope == :admin
    root_path
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def unexpired?
    ENV['EXPIRED_DATE'] && Time.zone.today < Date.parse(ENV['EXPIRED_DATE'])
  end

  # Guest to real
  def user_convertor
    # guest user become real user business logics
  end

  def create_guest_user
    user = User.guests.create(mobile: Faker::PhoneNumber.phone_number, password: '123456')
    session[:guest_user_id] = user.id
    user
  end
end
