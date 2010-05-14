class MissedBookingJob < Struct.new(:booking_id)
  
  def perform
    booking = Booking.find booking_id
    return unless booking.missed?
    sms = Sms.create do |s|
      s.text = SmsContent.missed_booking(booking)
      s.to = booking.client.phone
    end
    sms.dispatch or Rails.logger.error "Could not notify #{booking.client.first_name} (#{booking.client.id}) about the missed cleaning job"
    Rails.logger.info "Notified #{booking.client.first_name} (#{booking.client.id}) about the missed job"
  end
  
end