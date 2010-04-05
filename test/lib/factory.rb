module Factory

  def self.included(base)
    base.extend(self)
  end

  def build(params = {})
    raise "There are no default params for #{self.name}" unless self.respond_to?('factory_' + self.name.underscore)
    Postcode.any_instance.stubs(:geocode)
    new(self.send('factory_' + self.name.underscore).merge(params))
  end

  def build!(params = {})    
    obj = build(params)
    begin
      obj.save!
    rescue Exception => e
      puts "#{obj.class} couldn't be saved: " + obj.errors.inspect
      raise e
    end
    obj.reload # reload gets rid of user.password in memory, which makes the model think we're changing the password and freak out otherwise
  end

  def factory_cleaner
    {
      :name => Name.build,
      :postcode => Postcode.find_or_create_by_normalized_value('E1W 3TJ'),
      :contact_details => ContactDetails.build,
      :availability => Availability.build,
      :skills => Skills.build,
      :description => "I am the best cleaner ever! I won British Cleaner of the Year award twice!",
      :minimum_hire => 1,
      :rate => 10,
      :surcharge => 2,
      :user => User.build      
    }
  end
  
  def factory_name
    {
      :honorific => 'Miss',
      :first_name => 'Evita',
      :last_name => 'Peron',
    }
  end
  
  def factory_postcode
    {
      :value => 'E1W 3TJ',
      :latitude => -0.0542642,
      :longitude => 51.5057971
    }
  end
  
  def factory_contact_details
    {
      :email => "evita.peron#{rand(1000000)}@gmail.com",
      :phone => "07923#{'%06d' % rand(1000000)}"
    }
  end
  
  def factory_availability
    {
      :monday => 0b1111111100000000,
      :tuesday => 0,
      :wednesday => 0,
      :thursday => 0,
      :friday => 0,
      :saturday => 0,
      :sunday => 0
    }
  end
  
  def factory_skills
    {
      :domestic_cleaning => true
    }
  end
  
  def factory_sms
    {
      :from => Sms::OWN_NUMBER,
      :to => '447923374199',
      :text => 'test'
    }
  end
  
  def factory_user
    {
      :login => "test#{rand(1000000)}@test.com",
      :password => 'test12',
      :password_confirmation => 'test12'
    }
  end
  
  def factory_booking
    {
      :client => Client.build,
      :cleaner => Cleaner.build,
      :cleaning_materials_provided => false,
      :start_time => Time.parse('29 March 2010 10:00'),
      :end_time => Time.parse('29 March 2010 14:00')
    }
  end
  
  def factory_client
    {
      :address => Address.build,
      :name => Name.build,
      :contact_details => ContactDetails.build,
      :terms_and_conditions => '1',
      :user => User.build      
    }
  end
  
  def factory_address
    {
      :first_line => '60 Prospect Place',
      :second_line => 'Wapping Wall',
      :third_line => nil,
      :city => 'London',
      :postcode => Postcode.find_or_create_by_normalized_value('E1W 3TJ')
    }
  end

end

ActiveRecord::Base.class_eval do
  include Factory
end