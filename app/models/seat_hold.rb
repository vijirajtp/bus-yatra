class SeatHold < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :trip
  has_many :trip_seats

  ## Scopes
  scope :active, -> { where("expires_at > ?", Time.current) }
end
