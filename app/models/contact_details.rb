class ContactDetails < ActiveRecord::Base
  
  validates_presence_of :email, :message => "^Please enter your e-mail address"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => '^Please enter a valid e-mail address'
  validates_format_of :phone, :with => /\+?\d+/, :message => '^Please enter a valid phone number'
  
end
