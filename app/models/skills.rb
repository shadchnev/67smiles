class Skills < ActiveRecord::Base
  
  validates_presence_of :domestic_cleaning, :message => '^Please select at least domestic cleaning as a skill'
  
end
