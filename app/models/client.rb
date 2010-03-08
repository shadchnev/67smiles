class Client < ActiveRecord::Base
  
  belongs_to :name
  belongs_to :contact_details  
  belongs_to :address
  has_many :bookings
  
  accepts_nested_attributes_for :name  
  accepts_nested_attributes_for :contact_details  
  accepts_nested_attributes_for :address
  
  validates_acceptance_of :terms_and_conditions, :message => "^Please check the 'Terms and conditions' checkbox if you agree with them"
  
end
