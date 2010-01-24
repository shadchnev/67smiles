class Postcode < ActiveRecord::Base
  
  validates_presence_of :value, :message => "^Please enter your postcode"
  
end
