require 'test_helper'

class BookingsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "parameters are parsed properly" do
    cleaner = Cleaner.build!
    post :create, {"booking_date"=>"16/02/2010", "booking"=>{"start_time"=>"08:00", "end_time"=>"10:00", "cleaning_materials_provided"=>"0"}, "commit"=>"Hire Emma", "cleaner_id"=>cleaner.id}
    booking = Booking.first
    assert booking
    assert_redirected_to cleaner_booking_path(cleaner.id, booking)
    assert_equal Time.parse('16/02/2010 08:00'), booking.start_time
    assert_equal Time.parse('16/02/2010 10:00'), booking.end_time
    assert_equal false, booking.cleaning_materials_provided
    assert_equal cleaner.id, booking.cleaner.id
  end
end
