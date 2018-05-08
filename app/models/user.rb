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
  after_create_commit :send_welcome_email
  before_update :ensure_not_depot_admin, if: :depot_admin?
  before_destroy :ensure_not_depot_admin, if: :depot_admin?

  has_many :orders, dependent: :restrict_with_error
  has_many :line_items, through: :orders

  has_one :address
  accepts_nested_attributes_for :address

  private

  def ensure_a_user_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def ensure_not_depot_admin
    errors.add(:base, "Unauthorised action")
    throw :abort
  end

  def depot_admin?
    email == DEFAULT_ADMIN_EMAIL
  end
end
