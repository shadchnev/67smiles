# Understands how to write a text to a user
class SmsContent
  
  def self.booking_enquiry(booking)
    text = "VarsityCleaners: job offer in #{booking.postcode}."
    text << " #{booking_date(booking)} "
    text << booking_start_time(booking)
    text << ' - '
    text << booking_end_time(booking)
    text << (booking.cleaning_materials_provided? ? ' (cleaning stuff provided). ' : ' with own cleaning stuff. ')
    text << "Will pay #{round_if_possible booking.cost} pounds. "
    text << "Accept? Reply 'yes' or 'no' before #{booking_reply_deadline}"
    text
  end
  
  def self.booking_accepted_for_client(booking)    
    text = "#{booking.cleaner.first_name} has accepted the booking for #{booking.start_time.strftime('%d %B')}."
    text << (booking.cleaning_materials_provided? ? ' You will be expected to provide cleaning materials.' : " Cleaning materials will be provided by #{booking.cleaner.first_name}.")
    text
  end
  
  def self.booking_accepted_for_cleaner(booking)    
    "Thank you, #{booking.cleaner.first_name}! Please log in on varsitycleaners.co.uk to see full details of the job."
  end
  
  def self.booking_declined_for_client(booking)    
    "#{booking.cleaner.first_name} has declined the booking for #{booking.start_time.strftime('%d %B')}. Please feel free to make another booking with #{booking.cleaner.first_name} or any other cleaner."
  end
  
  def self.new_user(user)
    "Aaaaaaaa! New user! (#{user.owner.contact_details.email})"
  end
  
  def self.cleaner_reminder(booking)
    "Your Varsity Cleaners job at #{booking.client.postcode} is on #{booking_date(booking)}, between #{booking_start_time(booking)} and #{booking_end_time(booking)}. Please cancel online if you can't make it"
  end
  
  def self.missed_booking(booking)
    "We're sorry but #{booking.cleaner.first_name} did not reply to confirm the booking, so do not expect #{booking.cleaner.first_name} to come. Please feel free to choose another cleaner on the website!"
  end
  
  def self.confirmation_code(code)
    "Your confirmation code is #{code}. Thank you for registering on Varsity Cleaners!"
  end
  
  def self.new_password(password)
    "This is the password that you requested: #{password}"
  end
  
private

  def self.booking_date(booking)
    booking.start_time.localtime.strftime('%d %B') 
  end
  
  def self.booking_start_time(booking)
    booking.start_time.localtime.to_s(:time)
  end

  def self.booking_end_time(booking)
    booking.end_time.localtime.to_s(:time)
  end

  def self.round_if_possible(val)
    (val.round.to_i - val) == 0 ? val.to_i : '%2.2f' % val
  end

  def self.booking_reply_deadline
    (Time.now + CLEANER_REPLY_TIMEOUT).to_s :time
  end
  
end