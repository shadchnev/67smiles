class CleanerReminderJob < Struct.new(:booking_id)
  
  def perform
    booking = Booking.find(booking_id)
    return unless booking.active?
    sms = Sms.create do |s|
      s.text = SmsContent.cleaner_reminder(booking)
      s.to = booking.cleaner.phone
    end
    sms.dispatch or Rails.logger.error "Could not notify #{booking.cleaner.first_name} (#{booking.cleaner.id}) about the appointment"
    Rails.logger.info "Reminded #{booking.cleaner.first_name} (#{booking.cleaner.id}) about the job"
  end
  
end