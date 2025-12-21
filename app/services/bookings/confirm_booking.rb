module Bookings
  class ConfirmBooking
    
    def initialize(user:, trip:, hold_id:)
      @user = user
      @trip = trip
      @hold = SeatHold.find(hold_id)
    end

    def call
      ActiveRecord::Base.transaction do
        seats = TripSeat.where(trip: @trip, seat_hold_id: @hold.id).lock("FOR UPDATE").to_a

        raise "Seats already booked" if seats.any?(&:booked?)
        raise "Hold expired" if @hold.expires_at < Time.current

        booking = Booking.create!(
          user: @user,
          trip: @trip,
          total_amount: seats.count * @trip.price,
          status: :confirmed
        )

        seats.each do |seat|
          seat.update!(status: :booked, booking_id: booking.id)
        end

        @hold.destroy!

        booking
      end
    end
  end
end
