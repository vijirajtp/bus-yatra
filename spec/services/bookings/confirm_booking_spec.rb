require "rails_helper"

RSpec.describe Bookings::ConfirmBooking, type: :service do
  let(:customer) { create(:user, :customer) }
  let(:operator) { create(:operator) }
  let(:route) { create(:route) }
  let(:bus) { create(:bus, operator: operator) }

  let(:trip) do
    create(:trip,
      route: route,
      bus: bus,
      operator: operator,
      price: 1200
    )
  end

  let(:hold) do
    create(:seat_hold,
      user: customer,
      trip: trip,
      expires_at: 5.minutes.from_now
    )
  end

  let!(:seat1) { create(:seat, bus: bus) }
  let!(:seat2) { create(:seat, bus: bus) }

  let!(:ts1) { create(:trip_seat, trip: trip, seat: seat1, status: :held, seat_hold: hold) }
  let!(:ts2) { create(:trip_seat, trip: trip, seat: seat2, status: :held, seat_hold: hold) }

  describe "service call" do
    context "successful booking" do
      it "confirms booking and locks seats" do
        booking = described_class.new(
          user: customer,
          trip: trip,
          hold_id: hold.id
        ).call

        expect(booking).to be_present
        expect(booking.confirmed?).to be_truthy
        expect(booking.trip_seats.count).to eq(2)

        expect(ts1.reload.status).to eq("booked")
        expect(ts1.booking_id).to eq(booking.id)
      end
    end

    context "failure cases" do
      it "rejects if hold expired" do
        hold.update!(expires_at: 10.minutes.ago)

        expect {
          described_class.new(
            user: customer,
            trip: trip,
            hold_id: hold.id
          ).call
        }.to raise_error("Hold expired")
      end

      it "rejects if seats already booked" do
        ts1.update!(status: :booked)

        expect {
          described_class.new(
            user: customer,
            trip: trip,
            hold_id: hold.id
          ).call
        }.to raise_error("Seats already booked")
      end
    end
  end
end