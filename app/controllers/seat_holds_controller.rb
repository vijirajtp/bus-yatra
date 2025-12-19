class SeatHoldsController < ApplicationController

	def create
  		trip = Trip.find(params[:trip_id])
    begin
  		hold = SeatHolds::CreateHold.new(
        user: current_user,
        trip: trip,
        seat_ids: params[:seat_ids]
      ).call

      render json: { hold_id: hold.id, expires_at: hold.expires_at }
    rescue => e
      render json: { error: e.message }, status: 422
    end
	end
end
