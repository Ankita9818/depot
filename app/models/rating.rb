class Rating < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates :user_id, uniqueness: {
    scope: :product_id,
    message: :has_invalid_value }, if: :product_id?
end