class Cleaner < ActiveRecord::Base
  
  belongs_to :name
  belongs_to :postcode
  belongs_to :contact_details
  accepts_nested_attributes_for :name
  accepts_nested_attributes_for :postcode
  accepts_nested_attributes_for :contact_details
  
  def first_name
    name.first_name
  end
  
end
