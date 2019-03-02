module Commands
  class SetIdentifier
    attr_accessor :user, :identifier, :result

    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    validates_numericality_of :identifier, if: :identifier

    def execute
      return unless valid?

      User.with_advisory_lock(user.api_token) do
        user.update(identifier: identifier)
        @result = user.identifier
      end
    end
  end
end
