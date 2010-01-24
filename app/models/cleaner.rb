class Cleaner < ActiveRecord::Base
  
  belongs_to :name
  belongs_to :postcode
  accepts_nested_attributes_for :name
  accepts_nested_attributes_for :postcode
  
  def first_name
    name.first_name
  end
  
end
