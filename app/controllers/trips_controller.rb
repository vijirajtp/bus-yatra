class TripsController < ApplicationController

	def index
    @trips = Trip.search(params).paginate(page: params[:page], per_page: 10)
	end

	def show
    @trip = Trip.find(params[:id])
  end
end
