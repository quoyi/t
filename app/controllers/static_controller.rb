# frozen_string_literal: true

class StaticController < ApplicationController
  skip_before_action :authenticate_licence!

  # GET /
  def index
    redirect_to dashboard_path if current_or_guest_user
  end

  # GET /terms
  def terms
  end

  # GET /privacy
  def privacy
  end

  # GET /expired
  def expired
  end
end
