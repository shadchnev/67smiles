class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :type # for STI
      t.integer :cleaner_id
      t.integer :client_id
      t.integer :booking_id
      t.integer :review_id
      
      t.timestamps
    end
    Client.all.each do |c|
      NewClientEvent.create!(:client => c, :created_at => c.created_at, :updated_at => c.updated_at)
    end
    Cleaner.all.each do |c|
      NewCleanerEvent.create!(:cleaner => c, :created_at => c.created_at, :updated_at => c.updated_at)
    end
    Review.all.each do |r|
      NewReviewEvent.create!(:review => r, :created_at => r.created_at, :updated_at => r.updated_at)
    end
    Booking.all.each do |b|
      NewBookingEvent.create!(:booking => b, :created_at => b.created_at, :updated_at => b.updated_at)
    end
  end

  def self.down
    drop_table :events
  end
end
