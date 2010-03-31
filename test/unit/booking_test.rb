require 'test_helper'

class BookingTest < ActiveSupport::TestCase

  test "cost is calculated correctly when there's a surcharge" do
    booking = Booking.build :cleaning_materials_provided => true    
    assert_equal 48, booking.cost
  end
  
  test "cost is calculated correctly when there's no surcharge" do
    booking = Booking.build
    assert_equal 40, booking.cost
  end
  
  test "number of hours is calculated correctly" do
    booking = Booking.build :cleaning_materials_provided => true    
    assert_equal 4, booking.send(:number_of_hours)
  end
  
end
