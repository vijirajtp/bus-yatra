require "rails_helper"

RSpec.describe Bookings::CancelService, type: :service do
  let(:customer) { create(:user, :customer) }
  let(:operator) { create(:operator) }
  let(:route) { create(:route) }
  let(:bus) { create(:bus, operator: operator) }

  let(:trip) do
    create(:trip,
      route: route,
      bus: bus,
      operator: operator,
      departure_at: 5.hours.from_now
    )
  end

  let(:booking) do
    create(:booking,
      user: customer,
      trip: trip,
      status: :confirmed,
      total_amount: 1200
    )
  end

  let!(:seat1) { create(:seat, bus: bus) }
  let!(:seat2) { create(:seat, bus: bus) }

  let!(:ts1) { create(:trip_seat, trip: trip, seat: seat1, status: :booked, booking_id: booking.id) }
  let!(:ts2) { create(:trip_seat, trip: trip, seat: seat2, status: :booked, booking_id: booking.id) }

  describe "service call" do
    context "successful cancellation" do
      it "releases seats and applies refund" do
        service = described_class.new(booking: booking)
        result = service.call

        expect(result.status).to eq("cancelled")
        expect(result.cancelled_at).to be_present
        expect(result.refund_amount).to eq(1150)
        expect(result.cancellation_fee).to eq(50)

        expect(ts1.reload.status).to eq("available")
        expect(ts1.booking_id).to be_nil
      end
    end

    context "policy failures" do
      it "rejects if booking not confirmed" do
        booking.update!(status: :cancelled)

        expect {
          described_class.new(booking: booking).call
        }.to raise_error(Bookings::CancelService::Error, "Booking not confirmed")
      end

      it "rejects if within 1 hour of departure" do
        trip.update!(departure_at: 30.minutes.from_now)

        expect {
          described_class.new(booking: booking).call
        }.to raise_error(Bookings::CancelService::Error, "Cancellation allowed only up to 1 hour before departure.")
      end
    end
  end
end
