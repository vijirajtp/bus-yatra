class Trip < ApplicationRecord
  ## Associations
  belongs_to :route
  belongs_to :bus
  belongs_to :operator

  has_many :trip_seats, dependent: :destroy

  ## Scopes
  scope :desc, -> { order('created_at DESC') }
  scope :min_price, ->(amount) { where("price >= ?", amount.to_i) if amount.present? }
  scope :max_price, ->(amount) { where("price <= ?", amount.to_i) if amount.present? }
  scope :bus_type, ->(type) { joins(:bus).where(buses: { bus_type: type }) if type.present? }
  scope :operator_rating, ->(rating) { joins(:operator).where("operators.rating >= ?", rating.to_f) if rating.present? }
  scope :with_amenity, ->(key) { joins(:bus).where("buses.amenities ->> ? = 'true'", key) if key.present? }

  ## Validates
  validates :travel_date, :price, :departure_at, presence: true

  ## Methods
  def self.search(params)
    records = self.includes(:route, :bus, :operator)
    records = records.joins(:route).where("LOWER(routes.from_city) = LOWER(?) AND LOWER(routes.to_city) = LOWER(?)", params[:from], params[:to]) if params[:from].present? && params[:to].present?
    records = records.where(travel_date: params[:date]) if params[:date].present?
    records = records.min_price(params[:min_price]) if params[:min_price].present?
    records = records.max_price(params[:max_price]) if params[:max_price].present?
    records = records.bus_type(params[:bus_type]) if params[:bus_type].present?
    records = records.operator_rating(params[:rating]) if params[:rating].present?

    if params[:amenities].present?
      params[:amenities].each do |amenity|
        records = records.with_amenity(amenity)
      end
    end

    records
  end
end
