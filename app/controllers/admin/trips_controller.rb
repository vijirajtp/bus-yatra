class Admin::TripsController < AdminController

  before_action :find_trip, only: [:edit, :update]

	def index
    @trips = policy_scope(Trip).includes(:route, :bus, :operator).paginate(page: params[:page], per_page: 10)
  end

  def new
    @trip = Trip.new
    authorize @trip
  end

  def create
    @trip = Trip.new(trip_params)
    authorize @trip
    if @trip.save
      redirect_to admin_trips_path, notice: "Trip created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @trip
  end

  def update
    authorize @trip
    if @trip.update(trip_params)
      redirect_to admin_trips_path, notice: "Trip updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def trip_params
    params.require(:trip).permit(
      :route_id, :bus_id, :operator_id,
      :travel_date, :departure_at, :price
    )
  end

  def find_trip
    @trip = Trip.find(params[:id])
  end
end
