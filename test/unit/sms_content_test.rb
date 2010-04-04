require 'test_helper'

class SmsContentTest < ActiveSupport::TestCase
  
  test "booking enquiry with an integer cost" do
    booking = Booking.build(:start_time => Time.parse('20/03/2010 14:00'), :end_time => Time.parse('20/03/2010 18:00'))
    SmsContent.stubs(:booking_reply_deadline).returns '22:12'
    assert_equal "Job: 20 March 14:00 - 18:00 with own cleaning stuff. Will pay 48 pounds. Accept? Reply 'yes' or 'no' before 22:12", SmsContent.booking_enquiry(booking)
  end
  
  test "booking enquiry with a non-integer cost" do
    booking = Booking.build(:start_time => Time.parse('20/03/2010 14:00'), :end_time => Time.parse('20/03/2010 18:00'), :cleaning_materials_provided => true)
    booking.cleaner.rate = 11.3
    SmsContent.stubs(:booking_reply_deadline).returns '22:12'
    assert_equal "Job: 20 March 14:00 - 18:00 (cleaning stuff provided). Will pay 45.20 pounds. Accept? Reply 'yes' or 'no' before 22:12", SmsContent.booking_enquiry(booking)
  end
  
  
end
