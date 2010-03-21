# Understands physical location of an area in the UK
class Postcode < ActiveRecord::Base
  
  has_many :addresses
  
  validates_presence_of :value, :message => "^Please enter your postcode"
  validates_format_of :value, :with => /^([A-PR-UWYZ][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]?[0-9][ABD-HJLN-UW-Z]{2}|GIR0AA)$/i, :message => "^Please correct the postcode"
  
  acts_as_mappable
  
  before_validation_on_create :geocode, :if => lambda{|p| p.latitude.nil? or p.longitude.nil?}
  
  def value=(val)
    self[:value] = Postcode.normalize(val)
  end
  
  def area
    return 'GIR' if value == 'GIR0AA'
    value =~ /([a-z](?:[a-z]?\d{1,2}|\d[a-z]))\d[a-z]{2}/i 
    $1
  end    
  
  def self.find_by_value(val)
    super(normalize(val))
  end
  
private

  def geocode
    geo = Geokit::Geocoders::MultiGeocoder.geocode(value, :bias => 'uk')
    unless geo.success
      errors.add(:value, "^Postcode cannot be found") 
    else
      self.latitude, self.longitude = geo.lat,geo.lng
    end
  end
  
  def self.normalize(val)
    val.gsub(/[^\w\d]/, '').upcase if val
  end
  
end
