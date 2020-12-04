# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DeviseConcern

  protected

  def verify_complex_captcha?(model = nil, _opts = {})
    return verify_recaptcha(model: model, secret_key: ENV['RECAPTCHA_SECRET']) if ENV['RECAPTCHA_SECRET'].present?

    verify_rucaptcha?(model)
  end
end
