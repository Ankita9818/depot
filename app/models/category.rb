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

  has_many :products, dependent: :restrict_with_error, after_add: :increment_products_count, after_remove: :decrement_products_count
  has_many :sub_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  private

  def ensure_single_level_nesting
    if parent_category_id? && parent_category.parent_category.present?
      errors.add(:base, 'parent_category is itself a sub category')
    end
  end

  def increment_products_count(arg)
    Category.increment_counter(:products_count, parent_category) if parent_category.present?
  end

  def decrement_products_count(arg)
    Category.decrement_counter(:products_count, parent_category) if parent_category.present?
  end
end