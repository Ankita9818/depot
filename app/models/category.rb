class Category < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true, unless: :parent_category_id?, if: :name?
  validates :name, uniqueness: {
    allow_blank: true,
    scope: :parent_category_id,
    message: 'subcategory name should be unique'
  }, if: :parent_category_id?

  has_many :sub_categories, class_name: "Category",
                          foreign_key: "parent_category_id"

  belongs_to :parent_category, class_name: "Category", optional: true

  has_many :products, dependent: :restrict_with_error
  has_many :sub_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  after_destroy :destroy_subcategories
  before_validation :ensure_single_level_nesting

  private

  def ensure_single_level_nesting
    if parent_category_id? && Category.find(parent_category_id).parent_category_id?
      errors.add(:parent_category_id, 'is itself a sub category')
      throw :abort
    end
  end

  def destroy_subcategories
    sub_categories.each do |sub_cat|
      if sub_cat.products.empty?
        sub_cat.destroy
      end
    end
  end
end