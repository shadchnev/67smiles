class Address < ActiveRecord::Base
  
  belongs_to :postcode
  accepts_nested_attributes_for :postcode
  
end
