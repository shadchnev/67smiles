class Review < ActiveRecord::Base
  
  belongs_to :cleaner
  belongs_to :client
  
  validates_presence_of :cleaner  
  validates_presence_of :client
  validates_presence_of :text
  
  def timestamp
    created_at.to_formatted_s :short
  end
  
end
