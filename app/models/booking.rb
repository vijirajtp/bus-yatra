class Booking < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :trip
  has_many :trip_seats

  ## Enumerators
  enum :status, { confirmed: 0, cancelled: 1 }
end
