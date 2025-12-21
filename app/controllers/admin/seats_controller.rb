class Admin::SeatsController < AdminController
	
	before_action :find_bus
	before_action :find_seat, only: [:edit, :update]

  def index
    @seats = policy_scope(@bus.seats).paginate(page: params[:page], per_page: 10)
  end

  def new
    @seat = @bus.seats.new
    authorize @seat
  end

  def create
    @seat = @bus.seats.new(seat_params)
    authorize @seat

    if @seat.save
      redirect_to admin_bus_seats_path(@bus), notice: "Seat created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @seat
  end

  def update
    authorize @seat
  	if @seat.update(seat_params)
      redirect_to admin_bus_seats_path(@bus), notice: "Seat updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_bus
    @bus = Bus.find(params[:bus_id])
  end

  def find_seat
  	@seat = @bus.seats.find(params[:id])
  end

  def seat_params
    params.require(:seat).permit(:seat_number, :seat_row, :seat_column)
  end
end
