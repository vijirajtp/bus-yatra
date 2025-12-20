class AddRefundFieldsToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :cancelled_at, :datetime
    add_column :bookings, :refund_amount, :integer
    add_column :bookings, :cancellation_fee, :integer
  end
end
