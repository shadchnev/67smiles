class Cleaner < ActiveRecord::Base
  
  include BookingSelectors
  
  SEARCH_PROXIMITY = 10
  
  belongs_to :name, :dependent => :destroy
  belongs_to :postcode
  belongs_to :contact_details, :dependent => :destroy
  belongs_to :availability, :dependent => :destroy
  belongs_to :skills, :dependent => :destroy
  has_many :bookings
  has_many :reviews
  has_one :user, :as => :owner, :dependent => :destroy
  has_many :new_cleaner_events, :dependent => :destroy
  
  accepts_nested_attributes_for :name
  accepts_nested_attributes_for :postcode
  accepts_nested_attributes_for :contact_details
  accepts_nested_attributes_for :availability
  accepts_nested_attributes_for :skills
  accepts_nested_attributes_for :user
  
  validates_length_of :description, :in => 20..1000, :message => "^Did you write a paragraph about yourself? Please write no more than 1000 characters"
  validates_format_of :minimum_hire, :with => /[1-4]/, :message => "^Minimum hire must be between 1 and 4 hours"
  validates_numericality_of :rate, :message => "^Your hourly rate seems to be invalid", :less_than_or_equal_to => 50, :more_than_or_equal_to => 5
  validates_numericality_of :surcharge, :message => "^Your surcharge seems to be invalid", :less_than_or_equal_to => 10, :more_than_or_equal_to => 1
  
  validates_presence_of :availability
  validates_presence_of :contact_details
  
  validates_presence_of :user
  validate :university_email
  
  validates_acceptance_of :terms_and_conditions, :message => "^Please check the 'Terms and conditions' checkbox if you agree with them", :if => Proc.new{|c| c.new_record? and false} # DISABLED FOR NOW
  
  acts_as_mappable :through => :postcode
  
  has_attached_file :photo,
     :styles => {
       :thumb=> ["110x160", "png"],
       :medium  => ["228x310", "png"],
       :large => ["320x360", "png"]},
     :url => "/:attachment/:class/:id/:style/:basename.:extension",
     :path => ":rails_root/public/:attachment/:class/:id/:style/:basename.:extension"
  attr_protected :photo_file_name, :photo_content_type, :photo_size
  
  def self.find_suitable!(options)
    conditions = [options[:skills].search_conditions, 'active = 1']
    # conditions << "#{Date::DAYNAMES[options[:date].wday].downcase} > 0"
    cleaners = find(:all,
                    :within => SEARCH_PROXIMITY, 
                    :origin => options[:origin], 
                    :joins => [:skills, :availability, :user], 
                    :order => 'distance',
                    :conditions => conditions.join(" AND "))    
    !cleaners.empty? ? cleaners : raise("Sorry, no cleaners were found in your area. Please try using a different postcode")
  end
  
  def self.find_by_phone(number)
    find :first, :joins => :contact_details, :conditions => ['phone = ?', number]
  end
  
  def first_name
    name.first_name
  end
  
  def phone
    contact_details.phone
  end
  
  def email
    contact_details.email
  end
  
  def area
    postcode.area
  end
  
  def rate=(value)
    if value.kind_of? String
      value.gsub!(/[^\d.,]/, '') 
      value.gsub!(/,/, '.')
    end
    self[:rate] = (value.to_f * 10).round / 10.0 if value
  end
  
  def surcharge=(value)
    if value.kind_of? String
      value.gsub!(/[^\d.,]/, '') 
      value.gsub!(/,/, '.')
    end
    self[:surcharge] = (value.to_f * 10).round / 10.0 if value
  end
  
  def available?(from, to)    
    availability.available?(from, to)
  end
  
  def completed_jobs
    bookings.select{|b| b.completed?}
  end
  
  def missed_jobs
    bookings.select{|b| b.missed?}
  end
  
  def accepted_jobs
    bookings.select{|b| b.accepted?}
  end
  
  def has_reviews?
    reviews.count > 0
  end
  
  def available_on?(day)
    availability.send(day) > 0
  end
  
  def after_create
    NewCleanerEvent.create do |e|
      e.cleaner = self
    end
  end
  
private

  def university_email
    errors.add_to_base("The email must end with ac.uk to prove you are a student, e.g. john.smith12345@ic.ac.uk") unless contact_details.email.ends_with?('ac.uk')
  end
    
end
