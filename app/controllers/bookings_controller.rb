class BookingsController < ApplicationController

	before_action :check_seat_hold_expired?, only: [:confirm_booking, :create]
	before_action :find_booking, only: [:reschedule, :perform_reschedule, :destroy]

	def index
		@bookings = current_user.bookings
										.includes(trip: [:route], trip_seats: [:seat])
										.order(created_at: :desc)
										.paginate(page: params[:page], per_page: 10)
	end

	def confirm_booking
		@seats = TripSeat.where(trip: @trip, seat_hold_id: @hold.id).includes(:seat)
	end

	def create
		begin
			booking = Bookings::ConfirmBooking.new(
	      user: current_user,
	      trip: @trip,
	      hold_id: params[:hold_id]
	    ).call
	    
			redirect_to trip_booking_path(@trip, booking), notice: "Booking Confirmed"
		rescue => e
			redirect_to trip_path(@trip), alert: e
		end
	end

	def show
		@booking = current_user.bookings.includes(trip: [:route], trip_seats: [:seat]).find(params[:id])
	end

	def reschedule
		@available_trips = []
		return unless params[:new_date].present?

		@available_trips = Trip.where(route_id: @booking.trip.route_id, operator_id: @booking.trip.operator_id, travel_date: params[:new_date]).where.not(id: @booking.trip_id)
	end

	def perform_reschedule
		new_trip = Trip.find(params[:trip_id])

		begin
			Bookings::RescheduleService.new(booking: @booking, new_trip: new_trip).call

	  	redirect_to trip_path(new_trip), notice: "Trip changed successfully. Please select your seats again."
	  rescue Bookings::RescheduleService::Error => e
	  	redirect_back fallback_location: trip_booking_path(@booking, trip_id: @booking.trip.id), alert: e.message
	  end
	end

	def destroy
		begin
			Bookings::CancelService.new(booking: @booking).call

			redirect_to bookings_path, notice: "Booking cancelled successfully."
		rescue Bookings::CancelService::Error => e
			redirect_back fallback_location: trip_booking_path(@booking, trip_id: @booking.trip.id), alert: e.message
		end
	end


	private

	def check_seat_hold_expired?
		@trip = Trip.find(params[:trip_id])
		@hold = SeatHold.find(params[:hold_id]) rescue nil
		
		if @hold.nil? || @hold.expires_at < Time.current
			redirect_to trip_path(@trip), alert: "Seat hold expired. Please select seats again."
		end
	end

	def find_booking
		@booking = current_user.bookings.includes(trip: [:route], trip_seats: [:seat]).find(params[:id])
	end
end
