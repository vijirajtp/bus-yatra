class Admin::BusRoutesController < AdminController

  before_action :find_route, only: [:edit, :update]

	def index
    @routes = Route.all.paginate(page: params[:page], per_page: 10)
  end

  def new
    @route = Route.new
  end

  def create
    @route = Route.new(route_params)
    if @route.save
      redirect_to admin_bus_routes_path, notice: "Route created"
    else
      render :new
    end
  end

  def update
    if @route.update(route_params)
      redirect_to admin_bus_routes_path, notice: "Route updated"
    else
      render :edit
    end
  end

  private

  def route_params
    params.require(:route).permit(:from_city, :to_city)
  end

  def find_route
    @route = Route.find(params[:id])
  end
end
