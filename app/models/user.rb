class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token

  def increment_identifier
    self.identifier += 1
    save
  end
end
