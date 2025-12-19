class BookingsController < ApplicationController

	def create
		trip = Trip.find(params[:trip_id])

		booking = Bookings::ConfirmBooking.new(
      user: current_user,
      trip: trip,
      hold_id: params[:hold_id]
    ).call
    
		redirect_to trip_booking_path(booking), notice: "Booking Confirmed"
	end

	def show
	end
end
