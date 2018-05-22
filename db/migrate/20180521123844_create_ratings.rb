class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.references :product, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :score, precision: 2, scale: 1
    end
  end
end
