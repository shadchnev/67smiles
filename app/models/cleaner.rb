class Cleaner < ActiveRecord::Base
  
  belongs_to :name
  accepts_nested_attributes_for :name
end
