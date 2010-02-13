class Postcode < ActiveRecord::Base
  
  validates_presence_of :value, :message => "^Please enter your postcode"
  
  def area
    value.split(' ').first
  end
  
end
