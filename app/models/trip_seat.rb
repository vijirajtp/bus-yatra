class TripSeat < ApplicationRecord
  ## Associations
  belongs_to :trip
  belongs_to :seat

  ## Enumerators
  enum :status, { available: 0, held: 1, booked: 2 }
end
