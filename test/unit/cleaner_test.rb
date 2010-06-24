require 'test_helper'

class CleanerTest < ActiveSupport::TestCase

  test "rate is rounded" do
    cleaner = Cleaner.build
    cleaner.rate = 4.33
    assert_equal 4.3, cleaner.rate
    cleaner.rate = 5
    assert_equal 5, cleaner.rate
    cleaner.rate = 10.89
    assert_equal 10.9, cleaner.rate
  end
  
  test "is only available on monday by default" do
    cleaner = Cleaner.build
    from = Time.parse("15-02-2010 10:00")
    to = Time.parse("15-02-2010 12:00")
    assert cleaner.available?(from, to)
    assert !cleaner.available?(from + 1.day, to + 1.day)
  end
  
  test "can find by phone number" do
    cleaner = Cleaner.build!
    assert_equal cleaner, Cleaner.find_by_phone(cleaner.phone)
  end
  
  test "new cleaner event is created" do
    assert_equal 0, NewCleanerEvent.count
    cleaner = Cleaner.build!
    assert_equal 1, NewCleanerEvent.count
    assert_equal cleaner, NewCleanerEvent.first.cleaner
  end
  
  test "can assign strings to rate and surcharge" do
    c = Cleaner.build
    c.rate = '9.5'
    assert_equal 9.5, c.rate
    c.rate = '9,5'
    assert_equal 9.5, c.rate
    c.surcharge = '1.5'
    assert_equal 1.5, c.surcharge
    c.surcharge = '1,5'
    assert_equal 1.5, c.surcharge
  end
    
end
