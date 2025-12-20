class Admin::SeatsController < AdminController
	
	before_action :find_bus
	before_action :find_seat, only: [:edit, :update]

  def index
    @seats = @bus.seats.paginate(page: params[:page], per_page: 10)
  end

  def new
    @seat = @bus.seats.new
  end

  def create
    @seat = @bus.seats.new(seat_params)

    if @seat.save
      redirect_to admin_bus_seats_path(@bus), notice: "Seat created"
    else
      render :new
    end
  end

  def update
  	if @seat.update(seat_params)
      redirect_to admin_bus_seats_path(@bus), notice: "Seat updated"
    else
      render :edit
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
