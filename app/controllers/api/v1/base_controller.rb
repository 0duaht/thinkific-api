module Api::V1
  class BaseController < ActionController::API
    before_action :authenticate_request

    def authenticate_request
      @current_user = User.find_by(api_token: params[:api_token])
      head(401) unless @current_user.present?
    end
  end
end
