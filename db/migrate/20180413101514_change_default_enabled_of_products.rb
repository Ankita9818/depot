class ChangeDefaultEnabledOfProducts < ActiveRecord::Migration[5.1]
  def change
    change_column_default :products, :enabled, from: true, to: false
  end
end
