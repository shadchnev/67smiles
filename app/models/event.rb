class Event < ActiveRecord::Base
  # STI parent class

  belongs_to :cleaner
  
end
