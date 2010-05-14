require 'test_helper'

class MissedBookingJobTest < ActiveSupport::TestCase

  test "The message is sent" do
    Booking.any_instance.stubs(:after_create).returns true # to prevent another job from being created
    booking = Booking.build! :created_at => Time.now - 1.day
    Delayed::Job.enqueue MissedBookingJob.new(booking.id)
    Delayed::Worker.new(:quiet => true).work_off        
    assert_equal 3, Sms.count # two new users and a missed job notification
    assert_equal SmsContent.missed_booking(booking), Sms.last.text
    assert_equal booking.client.phone, Sms.last.to
  end
end
