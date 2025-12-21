class Route < ApplicationRecord
	## Associations
	has_many :trips

	## Validations
	validates :from_city, :to_city, presence: true

	## Scopes
  scope :desc, -> { order('created_at DESC') }
end
