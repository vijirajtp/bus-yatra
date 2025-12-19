class AddSeatHoldIdToTripSeats < ActiveRecord::Migration[8.1]
  def change
    add_column :trip_seats, :seat_hold_id, :integer
  end
end
