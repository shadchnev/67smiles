class Sms < ActiveRecord::Base
  
  belongs_to :booking
  
  validates_presence_of :to
  validates_presence_of :text
  
  validates_format_of :to, :with => /^447\d{9}$/
  
  def dispatch
    relay and create
  end
  
private

  def relay
    
  end
  
end
