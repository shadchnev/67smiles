class Cleaner < ActiveRecord::Base
  
  belongs_to :name
  belongs_to :postcode
  belongs_to :contact_details
  belongs_to :availability
  belongs_to :skills
  has_many :bookings
  
  accepts_nested_attributes_for :name
  accepts_nested_attributes_for :postcode
  accepts_nested_attributes_for :contact_details
  accepts_nested_attributes_for :availability
  accepts_nested_attributes_for :skills
  
  validates_length_of :description, :in => 20..1000, :message => "^Did you write a paragraph about yourself? Please write no more than 1000 characters"
  validates_format_of :minimum_hire, :with => /[1-4]/, :message => "^Minimum hire must be between 1 and 4 hours"
  validates_numericality_of :rate, :message => "^Your hourly rate seems to be invalid", :less_than_or_equal_to => 50, :more_than_or_equal_to => 5
  validates_numericality_of :surcharge, :message => "^Your surcharge seems to be invalid", :less_than_or_equal_to => 10, :more_than_or_equal_to => 1
  
  validates_presence_of :availability
  validates_associated :availability
  
  validates_acceptance_of :terms_and_conditions, :message => "^Please check the 'Terms and conditions' checkbox if you agree with them"
  
  def first_name
    name.first_name
  end
  
  def area
    postcode.area
  end
  
  def rate=(value)
    self[:rate] = (value.to_f * 10).round / 10.0
  end
  
  def available?(from, to)
    availability.available?(from, to)
  end
  
end
