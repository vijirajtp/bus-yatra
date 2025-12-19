class ExpireSeatHoldJob < ApplicationJob
  queue_as :default

  def perform(hold_id)
    hold = SeatHold.find_by(id: hold_id)
    return unless hold
    return if hold.expires_at > Time.current

    ActiveRecord::Base.transaction do
      seats = TripSeat.where(seat_hold_id: hold.id).lock("FOR UPDATE")

      seats.each do |seat|
        next if seat.booked?
        seat.update!(status: :available, seat_hold_id: nil)
      end

      hold.destroy!
    end
  end
end
