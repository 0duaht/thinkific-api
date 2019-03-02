module Api
  module V1
    class BaseController < ActionController::API
      def with_authenticated_lock
        return head(401) if params[:api_token].blank?

        User.with_advisory_lock(params[:api_token]) do
          user = User.find_by(api_token: params[:api_token])
          return head(401) unless user.present?

          yield(user)
        end
      end

      def authenticate_request
        return head(401) if params[:api_token].blank?

        @current_user = User.find_by(api_token: params[:api_token])
        head(401) unless @current_user.present?
      end
    end
  end
end
