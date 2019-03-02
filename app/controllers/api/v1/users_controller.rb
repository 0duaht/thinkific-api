module Api::V1
  class UsersController < BaseController
    skip_before_action :authenticate_request

    def create
      command = Commands::CreateUser.new(user_params)

      if command.execute
        successful_creation(command.result)
      else
        failed_creation(command.errors)
      end
    end

    private

    def successful_creation(user)
      render json: {
        identifier: user.identifier,
        api_token: user.api_token
      }, status: 201
    end

    def failed_creation(errors)
      render json: {
        errors: errors.full_messages
      }, status: 400
    end

    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :identifier
      )
    end
  end
end
