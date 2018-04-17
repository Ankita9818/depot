class AddDetailsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :enabled, :boolean
    add_column :products, :discount_price, :decimal, precision: 8, scale: 2
    add_column :products, :permalink, :string
  end
end
