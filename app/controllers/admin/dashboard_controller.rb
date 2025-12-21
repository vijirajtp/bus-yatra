class Admin::DashboardController < AdminController
  
  def index
    authorize :dashboard, :index?
    @total_trips = policy_scope(Trip).count
    @total_routes = policy_scope(Route).count
    @total_buses = policy_scope(Bus).count
    @total_bookings = Booking.count
  end
end
