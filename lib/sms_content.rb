# Understands how to write a text to a user
class SmsContent
  
  def self.booking_enquiry(booking)
    text = "Job in #{booking.area}:"
    text << booking.start_time.strftime(' %d %B ')
    text << booking.start_time.localtime.to_s(:time)
    text << ' - '
    text << booking.end_time.localtime.to_s(:time)
    text << (booking.cleaning_materials_provided? ? ' (cleaning stuff provided). ' : ' with own cleaning stuff. ')
    text << "Will pay #{round_if_possible booking.cost} pounds. "
    text << "Accept? Reply 'yes' or 'no' before #{booking_reply_deadline}"
    text
  end
  
  def self.booking_accepted(booking)    
    text = "#{booking.cleaner.first_name} has accepted the booking for #{booking.start_time.strftime('%d %B')}."
    text << (booking.cleaning_materials_provided? ? ' You will be expected to provide cleaning materials.' : " Cleaning materials will be provided by #{booking.cleaner.first_name}.")
    text
  end
  
  def self.booking_declined(booking)    
    "#{booking.cleaner.first_name} has declined the booking for #{booking.start_time.strftime('%d %B')}. Please feel free to make another booking with Evita or any other cleaner."
  end
  
private

  def self.round_if_possible(val)
    (val.round.to_i - val) == 0 ? val.to_i : '%2.2f' % val
  end

  def self.booking_reply_deadline
    (Time.now + CLEANER_REPLY_TIMEOUT).to_s :time
  end
  
end