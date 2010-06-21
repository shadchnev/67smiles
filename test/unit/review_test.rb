require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  
  test "creates a review event" do
    assert_equal 0, NewReviewEvent.count
    Review.build!
    assert_equal 1, NewReviewEvent.count
  end
end
