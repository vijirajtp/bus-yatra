class AddIndexesToTripSeats < ActiveRecord::Migration[8.1]
  def change
    add_index :trip_seats, [:trip_id, :seat_id], unique: true
  end
end
