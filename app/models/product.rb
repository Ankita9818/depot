class Product < ApplicationRecord
  PERMALINK_REGEX = %r{\A([a-z0-9]+(-[a-z0-9]+){2,})\Z}i
  DESCRIPTION_REGEX = %r{\A(\S+(\s+\S+){4,9})\s*\Z}i

  validates :title, :description, :price, :permalink, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01, allow_blank: true }
  validates :title, uniqueness: true
  validates :permalink, uniqueness: true, format: {
    allow_blank: true,
    with: PERMALINK_REGEX,
    message: I18n.t('.invalid')
  }

  validates :image_url, presence: true, url: { allow_blank: true }

  # using regex
  validates :description, format: {
    with: DESCRIPTION_REGEX,
    allow_blank: true,
    message: I18n.t('.invalid')
  }

  validates :discount_price, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  # validates_with DiscountValidator
  validate :discount_price_cannot_be_greater_than_price_value

  # before_destroy :ensure_not_referenced_by_any_line_item
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items
  has_many :carts, through: :line_items
  has_many :images, dependent: :destroy
  belongs_to :category
  before_validation :set_default_title, unless: :title?
  before_validation :set_default_discount_price, unless: :discount_price?

  after_commit :evaluate_products_count

  scope :enabled, -> { where(enabled: true) }

  accepts_nested_attributes_for :images

  validate :associated_image_count

  private

  # def ensure_not_referenced_by_any_line_item
  #   unless line_items.empty?
  #     errors.add(:base, 'Line Items Present')
  #     throw :abort
  #   end
  # end

  def discount_price_cannot_be_greater_than_price_value
    if discount_price.present? && price.present? && discount_price > price
      errors.add(:discount_price, I18n.t('.errors.messages.invalid_discount'))
    end
  end

  def set_default_title
    self.title = 'abc'
  end

  def set_default_discount_price
    self.discount_price = price
  end

  def evaluate_products_count
    Category.find(category_id_previous_change.first).recompute_products_count if previous_changes.key?(:category_id) && category_id_previous_change.first.present?
    category.recompute_products_count
  end

  def associated_image_count
    errors.add(:base, I18n.t('.errors.messages.invalid_images', max_images: MAX_ALLOWED_IMAGES_FOR_A_PRODUCT)) if images.length > MAX_ALLOWED_IMAGES_FOR_A_PRODUCT
  end
end

