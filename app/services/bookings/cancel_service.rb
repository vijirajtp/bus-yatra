module Bookings
  class CancelService
    class Error < StandardError; end

    CANCELLATION_DURATION = 1.freeze
    CANCELLATION_FEE = 50.freeze

    def initialize(booking:)
      @booking = booking
    end

    def call
      validate!

      ActiveRecord::Base.transaction do
        release_seats
        apply_cancellation
      end

      @booking
    end

    private

    def validate!
      raise Error, "Booking not confirmed" unless @booking.confirmed?

      departure_time = @booking.trip.departure_at

      raise Error, "Cancellation allowed only up to #{CANCELLATION_DURATION.to_s} hour before departure." if departure_time <= CANCELLATION_DURATION.hour.from_now
    end

    def release_seats
      @booking.trip_seats.update_all(status: :available, booking_id: nil)
    end

    def apply_cancellation
      total_price = @booking.total_amount
      refund = [total_price - CANCELLATION_FEE, 0].max

      @booking.update!(
        status: :cancelled,
        cancelled_at: Time.current,
        cancellation_fee_cents: CANCELLATION_FEE,
        refund_amount_cents: refund
      )
    end
  end
end