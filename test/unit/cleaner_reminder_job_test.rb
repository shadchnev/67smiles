require 'test_helper'

class CleanerReminderJobTest < ActiveSupport::TestCase

  test "The message is sent" do
    Booking.any_instance.stubs(:after_create).returns true # to prevent another job from being created
    booking = Booking.build!
    booking.accept!
    Delayed::Job.enqueue CleanerReminderJob.new(booking.id)
    Delayed::Worker.new(:quiet => true).work_off        
    assert_equal 5, Sms.count # two new users, two acceptance sms, and a reminder
    assert_equal SmsContent.cleaner_reminder(booking), Sms.last.text
    assert_equal booking.cleaner.phone, Sms.last.to
  end
end
