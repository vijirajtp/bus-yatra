class AddRatingToOperators < ActiveRecord::Migration[8.1]
  def change
    add_column :operators, :rating, :float
  end
end
