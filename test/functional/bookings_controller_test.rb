require 'test_helper'

class BookingsControllerTest < ActionController::TestCase
  
  def setup
    Sms.any_instance.stubs(:dispatch).returns(true)
  end
 
  test "parameters are parsed properly" do
    cleaner = Cleaner.build!        
    post :create, {"booking_date"=>"1266192000", "booking"=>{"start_time"=>"8", "end_time"=>"10", "cleaning_materials_provided"=>"1"}, "commit"=>"Hire Emma", "cleaner_id"=>cleaner.id}
    booking = Booking.first
    assert booking 
    assert_redirected_to cleaner_path(cleaner)
    assert_equal Time.parse('15-02-2010 08:00'), booking.start_time
    assert_equal Time.parse('15-02-2010 10:00'), booking.end_time
    assert_equal true, booking.cleaning_materials_provided
    assert_equal cleaner.id, booking.cleaner.id
  end

end
