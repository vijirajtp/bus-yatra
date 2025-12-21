require "rails_helper"

RSpec.describe Bookings::RescheduleService, type: :service do
  let(:customer) { create(:user, :customer) }

  let(:operator) { create(:operator) }
  let(:route) { create(:route) }
  let(:bus) { create(:bus, operator: operator) }

  let(:trip_a) do
    create(:trip,
      route: route,
      bus: bus,
      operator: operator,
      travel_date: Date.today + 2.days
    )
  end

  let(:trip_b) do
    create(:trip,
      route: route,
      bus: bus,
      operator: operator,
      travel_date: Date.today + 4.days
    )
  end

  let!(:seat1) { create(:seat, bus: bus) }
  let!(:seat2) { create(:seat, bus: bus) }

  let!(:trip_seat_1) { create(:trip_seat, trip: trip_a, seat: seat1, status: :booked) }
  let!(:trip_seat_2) { create(:trip_seat, trip: trip_a, seat: seat2, status: :booked) }

  let(:booking) do
    create(:booking,
      user: customer,
      trip: trip_a,
      status: :confirmed
    )
  end

  before do
    booking.trip_seats << [trip_seat_1, trip_seat_2]
  end

  describe "service call" do
    context "successful reschedule" do
      it "moves booking to new trip and releases old seats" do
        service = described_class.new(booking: booking, new_trip: trip_b)

        result = service.call

        expect(result.trip).to eq(trip_b)

        expect(trip_seat_1.reload.status).to eq("available")
        expect(trip_seat_2.reload.status).to eq("available")
        expect(trip_seat_1.reload.booking_id).to be_nil

        expect(booking.reload.trip).to eq(trip_b)
      end
    end

    context "validation failures" do
      it "rejects if booking is not confirmed" do
        booking.update!(status: :cancelled)

        expect {
          described_class.new(booking: booking, new_trip: trip_b).call
        }.to raise_error(Bookings::RescheduleService::Error, "Booking not confirmed")
      end


      it "rejects if new trip is same trip" do
        expect {
          described_class.new(booking: booking, new_trip: trip_a).call
        }.to raise_error(Bookings::RescheduleService::Error, "Cannot reschedule to same trip")
      end

      it "rejects if new trip route is different" do
        other_route = create(:route, from_city: "Pune", to_city: "Mumbai")
        different_route_trip = create(:trip, route: other_route, operator: operator)

        expect {
          described_class.new(booking: booking, new_trip: different_route_trip).call
        }.to raise_error(Bookings::RescheduleService::Error, "You must reschedule within the same route")
      end

      it "rejects if operator is different" do
        other_operator = create(:operator)
        diff_operator_bus = create(:bus, operator: other_operator)
        diff_operator_trip = create(:trip, route: route, bus: diff_operator_bus, operator: other_operator)

        expect {
          described_class.new(booking: booking, new_trip: diff_operator_trip).call
        }.to raise_error(Bookings::RescheduleService::Error, "You must reschedule under the same operator")
      end
    end
  end
end
