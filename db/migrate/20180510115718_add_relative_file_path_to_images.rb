class AddRelativeFilePathToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :relative_filepath, :string
  end
end
