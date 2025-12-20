class Admin::DashboardController < AdminController
  
  def index
    @total_trips = Trip.count
    @total_routes = Route.count
    @total_buses = Bus.count
    @total_bookings = Booking.count
  end
end
