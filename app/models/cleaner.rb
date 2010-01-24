class Cleaner < ActiveRecord::Base
  
  belongs_to :name
  accepts_nested_attributes_for :name
  
  def first_name
    name.first_name
  end
  
end
