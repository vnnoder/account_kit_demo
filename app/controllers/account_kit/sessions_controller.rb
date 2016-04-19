module AccountKit
  class SessionsController < ApplicationController
    def new
      @user = User.new
    end

    def create
      require_app_secret
      @access_token, @expires_at, @user_id = access_token(params[:code])
      response = AccountKit.me(@access_token)
      json_response = JSON.parse(response.body)
      @email_arddess = json_response['email']['address'] if json_response['email']
      @phone_number = json_response['phone']['number'] if json_response['phone']
      render 'signed_in'
    end

    private

    def require_app_secret
      AccountKit.configure do |config|
        config.require_app_secret = params[:require_app_secret].present?
      end
    end

    def access_token(code)
      response = AccountKit.access_token(code)
      json_response = JSON.parse(response.body)
      [json_response['access_token'], json_response['token_refresh_interval_sec'], json_response['id']]
    end
  end
end
