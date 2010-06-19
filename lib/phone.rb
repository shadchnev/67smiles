class Phone
  
  def self.normalize(phone)
    return unless phone and phone.is_a? String
    phone.gsub! /(\s|\(0\)|\+)/, ''    
    phone.gsub! /^0/, '44'        
    phone =~ /^447([5789]\d{8}|624\d{6})$/ ? phone : nil
  end
    
end