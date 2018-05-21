class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart, counter_cache: true

  validates :product_id, uniqueness: {
    scope: :cart_id,
    message: :has_invalid_value }, if: :cart_id?

  delegate :price, :title, to: :product, allow_nil: true

  def total_price
    price * quantity
  end
end
