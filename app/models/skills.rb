class Skills < ActiveRecord::Base
  
  validates_presence_of :domestic_cleaning, :message => '^Please select at least domestic cleaning as a skill'
  
  def search_conditions    
    self.class.skill_set.map{|s| send(s) ? "#{s} > 0" : nil}.reject{|v| v.nil?}.join(" AND ")
  end
  
  def empty?
    domestic_cleaning? or ironing? or groceries? or pets? == false
  end
  
  def self.skill_set
    [:domestic_cleaning, :ironing, :groceries, :pets]
  end

end
