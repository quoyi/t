# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin!

  protected

  def authenticate_admin!
    redirect_to main_app.root_url, error: 'Access denied.' unless current_user&.admin?
  end
end
