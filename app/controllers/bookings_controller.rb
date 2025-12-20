class BookingsController < ApplicationController

	before_action :check_seat_hold_expired?, except: [:index, :show]

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
	end

	private

	def check_seat_hold_expired?
		@trip = Trip.find(params[:trip_id])
		@hold = SeatHold.find(params[:hold_id]) rescue nil
		
		if @hold.nil? || @hold.expires_at < Time.current
			redirect_to trip_path(@trip), alert: "Seat hold expired. Please select seats again."
		end
	end
end
