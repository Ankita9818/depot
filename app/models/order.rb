class Order < ApplicationRecord
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  has_many :line_items, dependent: :destroy
  belongs_to :user, optional: true

  scope :by_date, ->(from_date = Time.current.beginning_of_day, to_date = Time.current.end_of_day){ where created_at: from_date..to_date }

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
