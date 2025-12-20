class Admin::TripsController < AdminController

  before_action :find_trip, only: [:edit, :update]

	def index
    @trips = Trip.includes(:route, :bus, :operator).paginate(page: params[:page], per_page: 10)
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to admin_trips_path, notice: "Trip created"
    else
      render :new
    end
  end

  def update
    if @trip.update(trip_params)
      redirect_to admin_trips_path, notice: "Trip updated."
    else
      render :edit
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
