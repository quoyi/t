# frozen_string_literal: true

Rails.application.routes.draw do
  draw :admin
  draw :auth
  draw :subdomain
  draw :users

  controller :static do
    get :terms, :privacy, :expired
  end

  root 'static#index'
end
