module Bookings
  class RescheduleService
    class Error < StandardError; end

    def initialize(booking:, new_trip:)
      @booking = booking
      @new_trip = new_trip
    end

    def call
      validate!

      ActiveRecord::Base.transaction do
        release_old_seats
        move_booking_to_new_trip
      end

      @booking
    end

    private

    def validate!
      raise Error, "Booking not confirmed" unless @booking.confirmed?
      raise Error, "You must reschedule within the same route" unless @new_trip.route_id == @booking.trip.route_id
      raise Error, "You must reschedule under the same operator" unless @new_trip.operator_id == @booking.trip.operator_id
      raise Error, "Cannot reschedule to same trip" if @new_trip.id == @booking.trip_id
    end

    def release_old_seats
      @booking.trip_seats.update_all(status: :available, booking_id: nil)
    end

    def move_booking_to_new_trip
      @booking.update!(trip: @new_trip)
    end
  end
end