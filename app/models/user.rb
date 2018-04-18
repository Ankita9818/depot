class User < ApplicationRecord
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true, format: {
    with: EMAIL_REGEX,
    message: 'has invalid format',
  }
  has_secure_password
  after_destroy :ensure_a_user_remains
  private

  def ensure_a_user_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end
