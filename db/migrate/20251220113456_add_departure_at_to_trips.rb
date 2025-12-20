class AddDepartureAtToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :departure_at, :datetime, null: false
  end
end
