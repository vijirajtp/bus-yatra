class CreateRoutes < ActiveRecord::Migration[8.1]
  def change
    create_table :routes do |t|
      t.string :from_city
      t.string :to_city

      t.timestamps
    end
  end
end
