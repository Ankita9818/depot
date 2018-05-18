class AddLanguagePreferanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :language, :string, null: false, default: :en
  end
end
