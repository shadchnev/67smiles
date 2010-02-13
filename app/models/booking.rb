class Booking < ActiveRecord::Base
  
  belongs_to :cleaner
  belongs_to :client
  
end
