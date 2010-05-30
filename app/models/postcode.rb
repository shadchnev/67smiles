# Understands physical location of an area in the UK
class Postcode < ActiveRecord::Base
  
  has_many :addresses
  
  validates_presence_of :value, :message => "^Please enter your postcode"
  validates_format_of :value, :with => /^([A-PR-UWYZ][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]?[0-9][ABD-HJLN-UW-Z]{2}|GIR0AA)$/i, :message => "^Please correct the postcode"
  
  acts_as_mappable :lat_column_name => :latitude, :lng_column_name => :longitude
  
  after_validation_on_create :geocode, :if => lambda{|p| !p.errors.invalid?(:value) and (p.latitude.nil? or p.longitude.nil?)}
  
  def value=(val)
    self[:value] = Postcode.normalize(val)
  end
    
  def self.find_by_normalized_value(val)
    find_by_value(normalize(val))
  end
  
  def self.find_or_create_by_normalized_value(val)
    find_or_create_by_value(normalize(val))
  end
  
  def area
    split.first
  end
  
  def to_s
    split.join ' '
  end
  
private

  def split
    return [] unless value
    value =~ /(.+)(.{3})/i 
    [$1, $2]
  end      

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
