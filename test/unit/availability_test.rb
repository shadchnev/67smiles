require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  
  test "bits are counted correctly" do
    a = Availability.new
    assert_equal 0, a.send(:bits, 0)
    assert_equal 1, a.send(:bits, 0b1)
    assert_equal 1, a.send(:bits, 0b10)
    assert_equal 2, a.send(:bits, 0b11)
    assert_equal 4, a.send(:bits, 0b1111)
    assert_equal 1, a.send(:bits, 0b10000)
  end
  
  test "availability for less than 8 hours is bad" do
    a = Availability.new
    a.monday = 0b1111111
    assert !a.valid?
    a.friday = 0b1
    assert a.valid?
  end
  
end
