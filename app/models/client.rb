class Client < ActiveRecord::Base
  
  include BookingSelectors
  
  belongs_to :name, :dependent => :destroy
  belongs_to :contact_details, :dependent => :destroy
  belongs_to :address, :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_one :user, :as => :owner, :dependent => :destroy  
  has_many :new_client_events, :dependent => :destroy
  
  accepts_nested_attributes_for :name  
  accepts_nested_attributes_for :contact_details  
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :user
    
  validates_acceptance_of :terms_and_conditions, :message => "^Please check the 'Terms and conditions' checkbox if you agree with them", :if => Proc.new{|c| c.new_record? and false} # DISABLED FOR NOW!
  
  validates_presence_of :user
  
  def first_name
    name.first_name
  end
  
  def area
    postcode.area
  end  
  
  def email
    contact_details.email
  end
  
  def phone
    contact_details.phone
  end
  
  def postcode
    address.postcode
  end
  
  def after_create
    NewClientEvent.create!(:client => self)
  end
    
end
