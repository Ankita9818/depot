desc 'updating categories of products already present in database'
task port_legacy_products: :environment do
  Product.where(category_id: nil).update_all(category_id: Category.first.id)
  Category.first.send :recompute_products_count
end
