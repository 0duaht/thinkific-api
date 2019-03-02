module Commands
  class CreateUser
    attr_accessor :email, :password, :identifier, :result

    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    before_validation :downcase_email

    validate :unique_email?
    validate :valid_email?
    validates :password, presence: true
    validates_numericality_of :identifier, if: :identifier

    def execute
      return unless valid?

      user = User.create(user_attrs)
      return nil unless user.persisted?

      @result = {
        identifier: user.identifier,
        api_token: user.api_token
      }
    end

    private

    def downcase_email
      self.email = email&.downcase
    end

    def unique_email?
      errors.add(:email, ' already taken') if User.where(email: email).exists?
    end

    def valid_email?
      return if EmailAddress.valid?(email)

      errors.add(:email, ' invalid. Please check entry and try again.')
    end

    def user_attrs
      base_attrs = {
        email: email,
        password: password
      }

      identifier.present? ? base_attrs.merge(identifier_hash) : base_attrs
    end

    def identifier_hash
      {
        identifier: identifier
      }
    end
  end
end
