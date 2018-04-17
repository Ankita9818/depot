class IrreversibleMigrationExample < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :zipcode, :string
  end

  def down
    change_column :users, :zipcode, :integer
  end
end
