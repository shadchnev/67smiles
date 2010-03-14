class Postcode < ActiveRecord::Base
  
  has_many :addresses
  
  validates_presence_of :value, :message => "^Please enter your postcode"
  validates_format_of :value, :with => /^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$/i, :message => "^Please correct the postcode"
  
  def area
    value.split(' ').first
  end
  
end
