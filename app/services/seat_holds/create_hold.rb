module SeatHolds
  class CreateHold
    HOLD_TIME = 5.minutes

    def initialize(user:, trip:, seat_ids:)
      @user = user
      @trip = trip
      @seat_ids = seat_ids
    end

    def call
      ActiveRecord::Base.transaction do
        seats = TripSeat.where(trip: @trip, seat_id: @seat_ids).lock("FOR UPDATE").to_a

        raise "Some seats do not exist!" if seats.size != @seat_ids.size
        raise "Seats already booked or held!" if seats.any? { |s| !s.available? }

        # Mark as held
        seats.each { |s| s.update!(status: :held) }

        hold = SeatHold.create!(
          user: @user,
          trip: @trip,
          expires_at: Time.current + HOLD_TIME
        )

        seats.each { |s| s.update!(seat_hold_id: hold.id) }

        ExpireSeatHoldJob.set(wait: HOLD_TIME).perform_later(hold.id)

        hold
      end
    end
  end
end
