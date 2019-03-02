module Api
  module V1
    class BaseController < ActionController::API
      def authenticate_request
        return head(401) if params[:api_token].blank?

        @current_user = User.find_by(api_token: params[:api_token])
        head(401) unless @current_user.present?
      end
    end
  end
end
