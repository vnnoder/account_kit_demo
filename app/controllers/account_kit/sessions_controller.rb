module AccountKit
  class SessionsController < ApplicationController
    before_action :config_app_secret, only: [:new]

    def new
      @user = User.new
    end

    def create
      @access_token, @expires_at, @user_id = access_token(params[:code])
      response = AccountKit.me(@access_token)
      json_response = JSON.parse(response.body)
      @email_arddess = json_response['email']['address'] if json_response['email']
      @phone_number = json_response['phone']['number'] if json_response['phone']
      render 'signed_in'
    end

    private

    def config_app_secret
      AccountKit.configure do |config|
        config.require_app_secret = params[:require_app_secret].present?
        config.app_id = params[:app_id] || app_id_for(params[:require_app_secret].present?)
        config.app_secret = params[:app_secret] || app_secret_for(params[:require_app_secret].present?)
      end
    end

    def access_token(code)
      response = AccountKit.access_token(code)
      json_response = JSON.parse(response.body)
      [json_response['access_token'], json_response['token_refresh_interval_sec'], json_response['id']]
    end

    def app_id_for(require_app_secret)
      require_app_secret ? '1804778196417244' : '981076428655293'
    end

    def app_secret_for(require_app_secret)
      require_app_secret ? '074f550a820718853e92422bb012b932' : '5e6353199a4fd713bb8b9be58428f42d'
    end
  end
end
