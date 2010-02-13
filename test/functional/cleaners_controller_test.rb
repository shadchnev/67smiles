require 'test_helper'

class CleanersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "availability is available" do
    cleaner = Cleaner.build!
    xhr :get, :availability, {:id => cleaner.id}
    assert_response :success
    assert_equal cleaner.availability.to_hash, JSON.parse(@response.body)
  end
end
