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

puts "===== Seeding data ====="

User.create!(email: Faker::Internet.unique.email, confirmed_at: Time.now, role: "admin")

puts "Admin created"

Bus.delete_all
Operator.delete_all

operator_user = User.create!(
		email: Faker::Internet.unique.email,
		password: "password123",
		confirmed_at: Time.now,
		role: "operator")

# ========= OPERATOR & BUS =========
operator = Operator.find_or_create_by!(name: "Kallada Travels", user_id: operator_user.id)
operator.buses.find_or_create_by!(name: "Scania", bus_type: "ac_sleeper")

puts "User (Operator Role), Operator and Bus created"

# ========= ROUTES =========
to_cities = ["Chennai", "Hyderabad", "Mumbai"]
["Banglore", "Delhi", "Trivandrum"].each_with_index do |from, index|
	Route.find_or_create_by!(from_city: from, to_city: to_cities[index])
end

puts "Route created"

# ========= SEATS =========
# Example: 2 rows x 2 columns layout

bus = Bus.first
Seat.where(bus: bus).delete_all

seat_layout = [
  ["A1", 1, 1],
  ["A2", 1, 2],
  ["B1", 2, 1],
  ["B2", 2, 2]
]

seat_layout.each do |seat_number, row, col|
  Seat.create!(
    bus: bus,
    seat_number: seat_number,
    seat_row: row,
    seat_column: col
  )
end

puts "Seats created: #{bus.seats.count}"

route = Route.first
operator = Operator.first
# ========= TRIP =========
trip = Trip.find_or_create_by!(
  route: route,
  bus: bus,
  operator: operator,
  travel_date: Date.today + 1.day,
  price: 1700,
  rating: 4.6,
  departure_at: Time.now + 1.day
)

puts "Trip created for #{trip.travel_date}"


# ========= TRIP SEATS =========
TripSeat.where(trip: trip).delete_all

bus.seats.each do |seat|
  TripSeat.create!(
    trip: trip,
    seat: seat,
    status: "available"
  )
end

puts "Trip seats created: #{trip.trip_seats.count}"

puts "===== Seeding data completed ====="
