class TripsController < ApplicationController

	def index
    cache_key = [
      "trip_search",
      params[:from],
      params[:to],
      params[:date],
      params[:min_price],
      params[:max_price],
      params[:bus_type],
      params[:rating],
      (params[:amenities] || []).sort,
      Trip.maximum(:updated_at)&.to_i
    ]

    @trips = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      Trip.search(params).paginate(page: params[:page], per_page: 10)
    end
	end

	def show
    @trip = Trip.find(params[:id])
    @seats = @trip.trip_seats.order(:id)
  end
end
