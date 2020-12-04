# frozen_string_literal: true

controller :auth do
  get 'auth/:provider/callback', to: 'auth#create'
end
