module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_request, only: :update

      def create
        command = Commands::CreateUser.new(user_params)

        if command.execute
          successful_user_creation(command.result)
        else
          failed_execution(command.errors)
        end
      end

      def current
        identifier = nil
        with_authenticated_lock do |user|
          identifier = user.identifier
        end

        render json: { identifier: identifier }, status: 200 if identifier
      end

      def next
        identifier = nil
        with_authenticated_lock do |user|
          user.increment_identifier
          identifier = user.identifier
        end

        render json: { identifier: identifier }, status: 200 if identifier
      end

      def update
        command = Commands::SetIdentifier.new(
          user_update_params.merge(user: @current_user)
        )

        if command.execute
          render json: { identifier: command.result }, status: 200
        else
          failed_execution(command.errors)
        end
      end

      private

      def successful_user_creation(user)
        render json: {
          identifier: user.identifier,
          api_token: user.api_token
        }, status: 201
      end

      def failed_execution(errors)
        render json: {
          errors: errors.full_messages
        }, status: 400
      end

      def user_params
        params.require(:user).permit(:email, :password, :identifier)
      end

      def user_update_params
        params.require(:user).permit(:identifier)
      end
    end
  end
end
