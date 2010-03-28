module Factory

  def self.included(base)
    base.extend(self)
  end

  def build(params = {})
    raise "There are no default params for #{self.name}" unless self.respond_to?('factory_' + self.name.underscore)
    new(self.send('factory_' + self.name.underscore).merge(params))
  end

  def build!(params = {})
    obj = build(params)
    obj.save!
    obj
  end

  def factory_cleaner
    {
      :name => Name.build,
      :postcode => Postcode.build,
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
      :phone => '07923374199'
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

end

ActiveRecord::Base.class_eval do
  include Factory
end