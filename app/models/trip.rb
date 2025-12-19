class Trip < ApplicationRecord
  ## Associations
  belongs_to :route
  belongs_to :bus
  belongs_to :operator

  has_many :trip_seats, dependent: :destroy

  ## Methods
  def self.search(params)
    records = self.includes(:route, :bus)
    records = records.joins(:route).where("LOWER(routes.from_city) = LOWER(?) AND LOWER(routes.to_city) = LOWER(?)", params[:from], params[:to]) if params[:from].present? && params[:to].present?
    records = records.where(travel_date: params[:date]) if params[:date].present?
    records
  end
end
