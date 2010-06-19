# Understands how to pretend to be a real client
class NoClient < Client
  
  def valid?
    true 
  end
  
  def save
    false
  end
  
  def save!
    raise 'NoClient cannot be saved'    
  end
  
end