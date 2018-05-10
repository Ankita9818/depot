class AddFieldsToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :filename, :string
    add_column :images, :content_type, :string
    rename_column :images, :url, :filepath
  end
end
