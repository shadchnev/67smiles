class Review < ActiveRecord::Base
  
  belongs_to :cleaner
  belongs_to :client
  
  validates_presence_of :cleaner  
  validates_presence_of :client
  validates_presence_of :text
  has_many :new_review_events, :dependent => :destroy
  
  def timestamp
    created_at.localtime.to_formatted_s :short
  end
  
  def after_create
    NewReviewEvent.create(:review => self)
  end
  
end
