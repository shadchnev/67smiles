class Name < ActiveRecord::Base 
  
  validates_presence_of :honorific, :message => "^Please specify whether you are Mr, Miss, Mrs or Ms"
  validates_presence_of :first_name, :message => "^Please enter your first name (e.g. Emma)"
  validates_presence_of :last_name, :message => "^Please enter your last name (e.g. Cameron)"
  
end
