class Admin::BusesController < AdminController

	before_action :find_bus, only: [:edit, :update]

	def index
    @buses = policy_scope(Bus).includes(:operator).paginate(page: params[:page], per_page: 10)
  end

  def new
    @bus = Bus.new
    authorize @bus
  end

  def create
    @bus = Bus.new(bus_params)
    authorize @bus
    if @bus.save
      redirect_to admin_buses_path, notice: "Bus created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @bus
  end

  def update
    authorize @bus
  	if @bus.update(bus_params)
      redirect_to admin_buses_path, notice: "Bus updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def bus_params
    params.require(:bus).permit(:name, :bus_type, :operator_id, amenities: {})
  end

  def find_bus
  	@bus = Bus.find(params[:id])
  end
end
