class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.references :route, null: false, foreign_key: true
      t.references :bus, null: false, foreign_key: true
      t.references :operator, null: false, foreign_key: true
      t.date :travel_date
      t.integer :price
      t.float :rating

      t.timestamps
    end
  end
end
