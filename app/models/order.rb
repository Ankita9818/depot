class Order < ApplicationRecord
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  has_many :line_items, dependent: :destroy
  belongs_to :user

  scope :by_date, ->(from_date = nil, to_date = nil) do
    to_date.present? ? (where created_at: from_date..to_date) :
                       (where("DATE(created_at) = ? ", Date.today))
  end
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
