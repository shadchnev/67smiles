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
  
  test "it can save itself to a hash" do
    a = Availability.new
    a.monday = 0b00110011
    a.friday = 0b11001100
    hash = {"monday" => 0b00110011, "tuesday" => 0, "wednesday" => 0, "thursday" => 0, "friday" => 0b11001100, "saturday" => 0, "sunday" => 0}
    assert_equal hash, a.to_hash
  end
  
  test "it knows when it's available" do
    a = Availability.new
    a.monday = 0b00110011
    from = Time.parse("15-02-2010 01:00")
    to = Time.parse("15-02-2010 02:00")
    assert a.available?(from, to)
    assert !a.available?(from, to + 1.hour)
    assert !a.available?(from + 1.day, to + 1.day)
  end
  
end
