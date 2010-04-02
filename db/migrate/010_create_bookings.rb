class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table  :bookings do |t|
      t.integer   :cleaner_id
      t.integer   :client_id
      t.datetime  :start_time
      t.datetime  :end_time
      t.boolean   :cleaning_materials_provided
      t.boolean   :accepted
      t.timestamps
    end
  end

  def self.down
    drop_table :bookings
  end
end
