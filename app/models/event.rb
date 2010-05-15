class Event < ActiveRecord::Base
  # STI parent class

  belongs_to :cleaner
  belongs_to :client
  belongs_to :review
  belongs_to :booking
  
end
