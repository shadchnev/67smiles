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
end
