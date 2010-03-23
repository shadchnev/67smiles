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
    
end
