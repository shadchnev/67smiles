class Address < ActiveRecord::Base
  
  belongs_to :postcode
  accepts_nested_attributes_for :postcode
  
  validates_presence_of :first_line, :message => "^Please enter the first line of your address"
  validates_presence_of :second_line, :message => "^Please enter the second line of your address", :if => Proc.new {|a| !a.errors.invalid? :first_line }
  validates_presence_of :city, :message => "^Please enter the city you live in"
  
  validates_presence_of :postcode
  
end
