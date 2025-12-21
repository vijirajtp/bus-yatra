class Admin::TripSeatsController < AdminController

	before_action :find_trip
  before_action :find_trip_seat, only: [:edit, :update]

  def index
    @trip_seats = policy_scope(@trip.trip_seats).includes(:seat).paginate(page: params[:page], per_page: 10)
  end

  def new
    @trip_seat = @trip.trip_seats.new
    authorize @trip_seat
  end

  def create
    @trip_seat = @trip.trip_seats.new(trip_seat_params)
    authorize @trip_seat

    if @trip_seat.save
      redirect_to admin_trip_trip_seats_path(@trip), notice: "Trip seat created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @trip_seat
  end

  def update
    authorize @trip_seat
    if @trip_seat.update(trip_seat_params)
      redirect_to admin_trip_trip_seats_path(@trip), notice: "Trip seat updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_trip
    @trip = Trip.find(params[:trip_id])
  end

  def find_trip_seat
    @trip_seat = TripSeat.find(params[:id])
  end

  def trip_seat_params
    params.require(:trip_seat).permit(:seat_id, :status)
  end
end
