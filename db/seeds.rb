# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

User.create(email: Faker::Internet.unique.email, confirmed_at: Time.now, role: "admin")

3.times do
	user = User.create(
		email: Faker::Internet.unique.email,
		password: "password123",
		confirmed_at: Time.now,
		role: "operator")

	["Kallada Travels", "Parveen Travels", "SRM Travels"].each do |op_name|
		operator = Operator.create(name: op_name, user_id: user.id)
		["Volvo", "Scania", "Tata"].each do |bus_name|
			operator.buses.create(name: bus_name, bus_type: Bus.bus_types.keys.shuffle.first)
		end
	end
end

to_cities = ["Chennai", "Hyderabad", "Mumbai"]
["Banglore", "Delhi", "Trivandrum"].each do |from|
	Route.create(from_city: from, to_city: to_cities.shuffle.first)
end
