class ContactDetails < ActiveRecord::Base
  
  validates_presence_of :email, :message => "^Please enter your e-mail address"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => '^Please enter a valid e-mail address'
  validates_format_of :phone, :with => /^447([5789]\d{8}|624\d{6})$/, :message => '^Please enter a valid mobile phone number'
  
  validates_uniqueness_of :phone, :message => "^This phone has already been used to create another profile"
  validates_uniqueness_of :email, :message => "^This email has already been used to create another profile"
  
  before_validation :normalize_phone
  
  def normalize_phone
    self.phone.gsub! /(\s|\(0\)|\+)/, ''    
    self.phone.gsub! /^0/, '44'    
  end
  
end
