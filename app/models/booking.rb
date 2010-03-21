class Booking < ActiveRecord::Base
  
  belongs_to :cleaner
  belongs_to :client
  
  validates_associated :cleaner
  # validates_associated :client
  
  validate :time_valid?
  validate :time_available?, :if => Proc.new{|b| b.time_valid? and b.cleaner }
  
  def time_valid?
    start_time and end_time and start_time.to_date == end_time.to_date and start_time.hour < end_time.hour
  end
  
  def time_available?
    errors.add_to_base("#{cleaner.name} is not available for hire at the specified time") unless cleaner.available?(start_time, end_time)
  end
  
  
end
