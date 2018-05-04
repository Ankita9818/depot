class AddProductCountToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :products_count, :integer
  end
end
