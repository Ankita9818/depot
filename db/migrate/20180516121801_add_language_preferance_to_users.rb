class AddLanguagePreferanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :language, :integer, null: false, default: 0
  end
end
