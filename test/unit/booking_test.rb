require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  
  def setup
    Postcode.any_instance.stubs(:geocode)
    # puts (self.instance_methods - Object.instance_methods).sort
  end

  test "cost is calculated correctly when theres a surcharge" do
    booking = Booking.build! 
    assert_equal 48, booking.cost
  end
  
  test "cost is calculated correctly when there's no surcharge" do
    booking = Booking.build! :cleaning_materials_provided => true
    assert_equal 40, booking.cost
  end
  
  test "number of hours is calculated correctly" do
    booking = Booking.build! :cleaning_materials_provided => true    
    assert_equal 4, booking.send(:number_of_hours)
  end
  
  test "can find the first booking for a given number" do
    cleaner = Cleaner.build!
    Booking.build!
    Booking.build! :cleaner => cleaner, :created_at => 1.week.ago
    Booking.build! :cleaner => cleaner, :accepted => true
    booking = Booking.build! :cleaner => cleaner
    Booking.build! :cleaner => cleaner
    Booking.build!
    assert_equal booking, Booking.first_pending_for(cleaner.phone)
    assert_nil Booking.first_pending_for('447900000000')
  end
  
  test "cleaner reminder and missed job is created" do
    assert_equal 0, Delayed::Job.count
    booking = Booking.build!
    assert_equal 2, Delayed::Job.count
  end
  
  test "new booking event is created" do
    assert_equal 0, NewBookingEvent.count
    booking = Booking.build!
    assert_equal 1, NewBookingEvent.count
    assert_equal booking, NewBookingEvent.first.booking
  end
  
end
