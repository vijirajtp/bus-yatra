class Seat < ApplicationRecord
  ## Associations
  belongs_to :bus

  ## Scopes
  scope :desc, -> { order('created_at DESC') }

  ## Validations
  validates :seat_number, :seat_row, :seat_column, presence: true
end
