class Category < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: {
    allow_blank: true,
    scope: :parent_category_id
  }
  validate :ensure_single_level_nesting

  has_many :sub_categories, class_name: "Category",
                          foreign_key: :parent_category_id, dependent: :destroy

  belongs_to :parent_category, class_name: "Category", optional: true

  has_many :products, dependent: :restrict_with_error
  has_many :sub_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  def recompute_products_count
    self.products_count = count_products
    save
    parent_category.recompute_products_count if parent_category.present?
  end

  private

  def ensure_single_level_nesting
    if parent_category_id? && parent_category.parent_category.present?
      errors.add(:base, 'parent_category is itself a sub category')
    end
  end

  def count_products
    Product.where(category_id: id).count + sub_products.count
  end
end
