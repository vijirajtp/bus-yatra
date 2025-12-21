class Bus < ApplicationRecord
  ## Assocations
  belongs_to :operator
  has_many :seats, dependent: :destroy
  has_many :trips

  ## Enumerators
  enum :bus_type, { ac_seater: 0, ac_sleeper: 1, non_ac_seater: 2, non_ac_sleeper: 3 }

  ## Scopes
  scope :desc, -> { order('created_at DESC') }

  ## Validations
  validates :name, :bus_type, presence: true

  store_accessor :amenities, :wifi, :charging_port, :water_bottle, :reading_lights
end
