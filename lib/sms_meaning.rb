# Understands the meaning of cleaners' replies to booking requests
class SmsMeaning
  
  def initialize(text)
    @text = text
    @understood = false
    understand!
  end
  
  def understood?
    @understood
  end
  
  def accepted?
    raise "Could not understand sms meaning: #{@text}" unless understood?
    yes?
  end
  
private

  def yes?
    !(@text =~ /\byes\b/i).nil?
  end
  
  def no?
    !(@text =~ /\bno\b/i).nil?
  end

  def understand!
    @understood = yes? ^ no?
  end
  
end