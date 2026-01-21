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

  after_update_commit :evaluate_products_count

  def recompute_products_count
    set_product_count
    parent_category.recompute_products_count if parent_category.present?
  end

  private

  def evaluate_products_count
    if previous_changes.key?(:parent_category_id)
      Category.find(parent_category_id_previous_change.first).recompute_products_count if parent_category_id_previous_change.first.present?
      parent_category.recompute_products_count if parent_category.present?
    end
  end

  def ensure_single_level_nesting
    if parent_category_id? && parent_category.parent_category.present? || sub_categories.present? && parent_category.present?
      errors.add(:base, :has_invalid_value)
    end
  end

  def set_product_count
    update_columns(products_count: products.count + sub_products.count)
  end
end
