class CreateSeatHolds < ActiveRecord::Migration[8.1]
  def change
    create_table :seat_holds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
