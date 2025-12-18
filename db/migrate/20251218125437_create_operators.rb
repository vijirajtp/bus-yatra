class CreateOperators < ActiveRecord::Migration[8.1]
  def change
    create_table :operators do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
