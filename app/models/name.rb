class Name < ActiveRecord::Base
  
  validates_presence_of :honorific, :first_name, :last_name
  
end
