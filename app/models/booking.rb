class Booking < ActiveRecord::Base
  
  belongs_to :cleaner
  belongs_to :client
  
  has_many :sms
  
  validates_associated :cleaner
  validates_associated :client
  
  validate :time_valid?
  validate :time_available?, :if => Proc.new{|b| b.errors.on_base.nil? and b.cleaner }
  
  def time_valid?
    errors.add_to_base("The booking time is invalid") unless start_time and end_time and start_time.to_date == end_time.to_date and start_time.hour < end_time.hour
  end
  
  def time_available?
    errors.add_to_base("#{cleaner.first_name} is not available for hire at the specified time") unless cleaner.available?(start_time, end_time)
  end
  
  def before_create
    sms = booking_sms
    if sms.dispatch
      self.sms << sms
    else
      errors.add_to_base("Sorry, I couldn't send a text message. Please try booking again") and false # to return false and prevent the object from being created
    end
  end
  
  def cost
    number_of_hours * (cleaner.rate + surcharge)
  end
  
private

  def number_of_hours
    end_time.hour - start_time.hour
  end

  def surcharge
    cleaning_materials_provided? ? cleaner.surcharge : 0
  end

  def booking_sms
    Sms.create do |sms|
      sms.to = cleaner.phone
      sms.text = SmsContent.booking_enquiry(self)
    end
  end
  
  
  
end
