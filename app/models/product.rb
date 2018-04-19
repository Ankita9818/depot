class Product < ApplicationRecord
  PERMALINK_REGEX = %r{\A([a-z0-9]+(-[a-z0-9]+){2,})\Z}i
  DESCRIPTION_REGEX = %r{\A(\S+(\s+\S+){4,9})\s*\Z}i
  HUMANIZED_ATTRIBUTES = {
    split_description_to_words: "Description"
  }

  validates :title, :description, :price, :permalink, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01, allow_blank: true }
  validates :title, uniqueness: true
  validates :permalink, uniqueness: true, format: {
    allow_blank: true,
    with: PERMALINK_REGEX,
    message: 'requires minimum 3 words seperated by hyphen without space or special characters'
  }

  validates :image_url, presence: true, url: { allow_blank: true }

  # using regex
  # validates :description, format: {
  #   with: DESCRIPTION_REGEX,
  #   allow_blank: true,
  #   message: 'should have minimum 5 to 10 words'
  # }

  #using length validator
  validates :split_description_to_words, length: {
    minimum: 5,
    maximum: 10,
    message: "must have between 5 to 10 words",
    allow_blank: true
  }

  validates :discount_price, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  validates_with DiscountValidator
  # validate :discount_price_cannot_be_greater_than_price_value

  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items Present')
      throw :abort
    end
  end

  def discount_price_cannot_be_greater_than_price_value
    if discount_price.present? && price.present? && discount_price > price
      errors.add(:discount_price, "can't be greater than price value")
    end
  end

  def split_description_to_words
    description.split(' ')
  end

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
