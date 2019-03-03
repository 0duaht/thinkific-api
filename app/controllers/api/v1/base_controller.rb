module Api
  module V1
    class BaseController < ActionController::API
      def authenticate_request
        api_token = request.headers['Authorization']&.split&.last
        return head(401) if api_token.blank?

        @current_user = User.find_by(api_token: api_token)
        head(401) unless @current_user.present?
      end
    end
  end
end
