class AddAmenitiesToBuses < ActiveRecord::Migration[8.1]
  def change
    add_column :buses, :amenities, :jsonb
  end
end
