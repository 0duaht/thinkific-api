module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_request, except: :create

      def create
        command = Commands::CreateUser.new(user_params)

        if command.execute
          successful_execution(command.result, 201)
        else
          failed_execution(command.errors)
        end
      end

      def current
        identifier = nil
        @current_user.with_lock do
          identifier = @current_user.identifier
        end

        successful_execution(identifier: identifier)
      end

      def next
        identifier = nil
        @current_user.with_lock do
          @current_user.increment_identifier
          identifier = @current_user.identifier
        end

        successful_execution(identifier: identifier)
      end

      def update
        command = Commands::SetIdentifier.new(
          user_update_params.merge(user: @current_user)
        )

        if command.execute
          successful_execution(identifier: command.result)
        else
          failed_execution(command.errors)
        end
      end

      private

      def successful_execution(response_hash, status = 200)
        render json: {
          data: {
            type: 'users',
            attributes: response_hash
          }
        }, status: status
      end

      def failed_execution(errors)
        render json: {
          errors: errors.full_messages
        }, status: 400
      end

      def user_params
        params.require(:data).permit(
          attributes: %i[email password identifier]
        )
      end

      def user_update_params
        params.require(:data).permit(attributes: %i[identifier])
      end
    end
  end
end
