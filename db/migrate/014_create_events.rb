class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :type # STI table
      
      t.integer :booking_id
      t.integer :cleaner_id
      t.integer :client_id
      t.integer :review_id
      t.decimal :old_rate, :precision => 4, :scale => 2
      t.decimal :new_rate, :precision => 4, :scale => 2      
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
