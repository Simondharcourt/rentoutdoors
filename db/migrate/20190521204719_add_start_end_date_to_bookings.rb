class AddStartEndDateToBookings < ActiveRecord::Migration[5.2]
  def change
    rename_column :bookings, :date, :start_date
    add_column :bookings, :end_date, :date
  end
end
