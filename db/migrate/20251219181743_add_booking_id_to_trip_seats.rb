class AddBookingIdToTripSeats < ActiveRecord::Migration[8.1]
  def change
    add_column :trip_seats, :booking_id, :integer
  end
end
