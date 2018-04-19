class Error < StandardError
end

class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true, format: {
    with: EMAIL_REGEX,
    message: 'has invalid format',
  }

  has_secure_password
  after_destroy :ensure_a_user_remains
  after_create :send_welcome_email
  before_destroy { ensure_user_is_not_admin('delete') }
  before_update { ensure_user_is_not_admin('update') }

  private

  def ensure_a_user_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end

  def ensure_user_is_not_admin(action)
    raise Error.new "Can not #{action} the admin" if self.email == 'admin@depot.com'
  end
end
