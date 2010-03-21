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
  
  test "cleaners can be found by postcode" do
    Cleaner.build! :postcode => Postcode.build!(:value => 'e1w 3tj', :longitude => nil, :latitude => nil)
    Cleaner.build! :postcode => Postcode.build!(:value => 'nw1 0du', :longitude => nil, :latitude => nil)
    Cleaner.build! :postcode => Postcode.build!(:value => 'AB101AA', :longitude => nil, :latitude => nil)    
    origin = Postcode.find_or_create_by_normalized_value('e1w 3tj')
    assert_equal 1, Cleaner.find_within(1, :origin => origin).size
    assert_equal 2, Cleaner.find_within(10, :origin => origin).size
    assert_equal 3, Cleaner.find_within(500, :origin => origin).size
  end
  
end
