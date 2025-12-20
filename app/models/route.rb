class Route < ApplicationRecord
	## Associations
	has_many :trips

	## Validations
	validates :from_city, :to_city, presence: true
end
