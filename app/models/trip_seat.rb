class TripSeat < ApplicationRecord
  ## Associations
  belongs_to :trip
  belongs_to :seat
  belongs_to :seat_hold, optional: true
  belongs_to :booking, optional: true

  ## Enumerators
  enum :status, { available: 0, held: 1, booked: 2 }

  ## Validations
  validates :seat_id, uniqueness: { scope: :trip_id }

  ## Scopes
  scope :desc, -> { order('created_at DESC') }
end
