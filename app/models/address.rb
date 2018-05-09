class Address < ApplicationRecord
  belongs_to :user

  validates :state, :city, :country, :pincode, presence: true
end
