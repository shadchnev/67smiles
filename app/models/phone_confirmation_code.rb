class PhoneConfirmationCode < ActiveRecord::Base
  
  def generate!
    self[:value] = rand(9000) + 1000
    save!
  end
  
  def dispatch!
    raise "Cannot dispatch the confirmation code to an unknown phone" unless phone
    text = SmsContent.confirmation_code(value)
    sms = Sms.create! do |s|
      s.to = phone
      s.text = text
    end        
    sms.dispatch or raise("Sorry, I couldn't send a text message with confirmation code to #{phone}. Text: #{text}")    
  end
  
end
