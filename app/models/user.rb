class User < ApplicationRecord
  has_secure_password

  def increment_identifier
    self.identifier += 1
    save
  end
end
