module Commands
  class IncrementIdentifier
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def call
      User.with_advisory_lock(user.id) do
        user.increment_identifier
      end
    end
  end
end
