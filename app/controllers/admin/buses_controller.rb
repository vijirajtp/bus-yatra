class Admin::BusesController < AdminController

	before_action :find_bus, only: [:edit, :update]

	def index
    @buses = Bus.includes(:operator).paginate(page: params[:page], per_page: 10)
  end

  def new
    @bus = Bus.new
  end

  def create
    @bus = Bus.new(bus_params)
    if @bus.save
      redirect_to admin_buses_path, notice: "Bus created."
    else
      render :new
    end
  end

  def update
  	if @bus.update(bus_params)
      redirect_to admin_buses_path, notice: "Bus updated."
    else
      render :edit
    end
  end

  private

  def bus_params
    params.require(:bus).permit(:name, :bus_type, :operator_id)
  end

  def find_bus
  	@bus = Bus.find(params[:id])
  end
end
