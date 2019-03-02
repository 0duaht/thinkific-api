module Commands
  class SetIdentifier
    attr_accessor :user, :identifier

    def initialize(user, identifier)
      @user = user
      @identifier = identifier
    end

    def call
      User.with_advisory_lock(user.id) do
        user.update(identifier: identifier)
      end
    end
  end
end
