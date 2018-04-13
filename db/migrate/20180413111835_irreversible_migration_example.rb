class IrreversibleMigrationExample < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :email
  end

  def down
    # It raises ActiveRecord::IrreversibleMigration exception
    # To roll back this migration , we would have to add it
    add_column :users, :email, :string
  end
end
