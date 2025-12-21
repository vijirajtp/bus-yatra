require "rails_helper"

RSpec.describe SeatHolds::CreateHold, type: :service do
  let(:customer) { create(:user, :customer) }
  let(:operator) { create(:operator) }
  let(:route) { create(:route) }
  let(:bus) { create(:bus, operator: operator) }

  let(:trip) do
    create(:trip,
      route: route,
      bus: bus,
      operator: operator
    )
  end

  let!(:seat1) { create(:seat, bus: bus) }
  let!(:seat2) { create(:seat, bus: bus) }

  let!(:ts1) { create(:trip_seat, trip: trip, seat: seat1, status: :available) }
  let!(:ts2) { create(:trip_seat, trip: trip, seat: seat2, status: :available) }

  describe "service call" do
    it "creates seat hold and marks seats held" do
      service = described_class.new(
        user: customer,
        trip: trip,
        seat_ids: [seat1.id, seat2.id]
      )

      hold = service.call

      expect(hold).to be_present
      expect(hold.trip_seats.count).to eq(2)
      expect(hold.expires_at).to be > Time.current

      expect(ts1.reload.status).to eq("held")
      expect(ts1.seat_hold_id).to eq(hold.id)
    end

    it "prevents holding already booked seat" do
      ts1.update!(status: :booked)

      expect {
        described_class.new(
          user: customer,
          trip: trip,
          seat_ids: [seat1.id]
        ).call
      }.to raise_error("Seats already booked or held!")
    end
  end
end
