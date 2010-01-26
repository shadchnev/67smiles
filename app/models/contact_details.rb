class ContactDetails < ActiveRecord::Base
  
  validates_presence_of :email, :message => "The email address must be entered"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'The email format is invalid'
  validates_format_of :phone, :with => /\+?\d+/, :message => 'The phone number is invalid'
  
end
