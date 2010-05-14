require 'test_helper'

class SmsContentTest < ActiveSupport::TestCase
  
  test "booking enquiry with an integer cost" do
    booking = Booking.build!(:start_time => Time.parse('05/04/2010 12:00'), :end_time => Time.parse('05/04/2010 16:00'))
    SmsContent.stubs(:booking_reply_deadline).returns '22:12'
    assert_equal "VarsityCleaners: job offer in E1W 3TJ. 05 April 12:00 - 16:00 with own cleaning stuff. Will pay 48 pounds. Accept? Reply 'yes' or 'no' before 22:12", SmsContent.booking_enquiry(booking)
  end
  
  test "booking enquiry with a non-integer cost" do
    cleaner = Cleaner.build(:rate => 11.3)
    booking = Booking.build!(:start_time => Time.parse('22/03/2010 12:00'), :end_time => Time.parse('22/03/2010 16:00'), :cleaning_materials_provided => true, :cleaner => cleaner)
    SmsContent.stubs(:booking_reply_deadline).returns '22:12'
    assert_equal "VarsityCleaners: job offer in E1W 3TJ. 22 March 12:00 - 16:00 (cleaning stuff provided). Will pay 45.20 pounds. Accept? Reply 'yes' or 'no' before 22:12", SmsContent.booking_enquiry(booking)
  end
  
  test "booking accepted" do
    booking = Booking.build!
    assert SmsContent.booking_accepted_for_client(booking) =~ /Evita has accepted the booking for \d\d \w+\. Cleaning materials will be provided by Evita\./
  end
  
  test "booking accepted for cleaner" do
    booking = Booking.build!
    assert_equal "Thank you, Evita! Please log in on varsitycleaners.co.uk to see full details of the job.", SmsContent.booking_accepted_for_cleaner(booking)
  end
  
  test "booking declined" do
    booking = Booking.build!
    assert SmsContent.booking_declined_for_client(booking) =~ /Evita has declined the booking for \d\d \w+\. Please feel free to make another booking with Evita or any other cleaner\./
  end
  
  test "cleaner reminder" do
    booking = Booking.build!
    assert SmsContent.cleaner_reminder(booking) =~ /Your Varsity Cleaners job at E1W 3TJ is on \d\d \w+, between 10:00 and 14:00\. Please cancel online if you can't make it/
  end
  
  
end
