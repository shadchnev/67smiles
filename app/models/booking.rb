class Booking < ActiveRecord::Base
  
  belongs_to :cleaner
  belongs_to :client
  
  has_many :sms
  
  validates_associated :cleaner
  # validates_associated :client
  
  validate :time_valid?
  validate :time_available?, :if => Proc.new{|b| b.time_valid? and b.cleaner }
  
  def time_valid?
    start_time and end_time and start_time.to_date == end_time.to_date and start_time.hour < end_time.hour
  end
  
  def time_available?
    errors.add_to_base("#{cleaner.first_name} is not available for hire at the specified time") unless cleaner.available?(start_time, end_time)
  end
  
  def before_create
    sms = Sms.create do |sms|
      sms.to = cleaner.phone
      sms.text = booking_sms      
    end
    if sms.sent?
      self.sms << sms
    else
      errors.add_to_base("Sorry, I couldn't send a text message. Please try booking again")
    end
    sms.sent?
    # false
  end
  
private
  
  def booking_sms
    "Job: 30 March, 11:00-15:00 at E1W 3TJ with own cleaning stuff. Will pay 48 pounds. Accept? Reply yes or no before 14:56"
  end
  
  
end
