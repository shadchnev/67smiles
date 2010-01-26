class Cleaner < ActiveRecord::Base
  
  belongs_to :name
  belongs_to :postcode
  belongs_to :contact_details
  
  accepts_nested_attributes_for :name
  accepts_nested_attributes_for :postcode
  accepts_nested_attributes_for :contact_details
  
  validates_length_of :description, :in => 20..1000, :message => "^Did you write a paragraph about yourself? Please write no more than 1000 characters"
  
  def first_name
    name.first_name
  end
  
end
