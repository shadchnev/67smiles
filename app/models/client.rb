class Client < ActiveRecord::Base
  
  belongs_to :name
  belongs_to :contact_details  
  belongs_to :address
  has_many :bookings
  has_many :reviews
  has_one :user, :as => :owner  
  
  accepts_nested_attributes_for :name  
  accepts_nested_attributes_for :contact_details  
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :user
    
  validates_acceptance_of :terms_and_conditions, :message => "^Please check the 'Terms and conditions' checkbox if you agree with them"
  
  validates_presence_of :user
  
  def first_name
    name.first_name
  end
  
  def area
    address.postcode.area
  end  
  
  
end
