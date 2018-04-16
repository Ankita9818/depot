class IrreversibleMigrationExample < ActiveRecord::Migration[5.1]
  # def up
  #   remove_column :users, :email
  # end

  # def down
  #   # It raises ActiveRecord::IrreversibleMigration exception
  #   # To roll back this migration , we would have to add it
  #   add_column :users, :email, :string
  # end
  def change
    reversible do |dir|
      change_table :products do |t|
        dir.up   { t.change :price, :decimal, :precision => 8, :scale => 3 }
        dir.down { t.change :price, :decimal, :precision => 8, :scale => 2 }
      end
    end
  end
end
