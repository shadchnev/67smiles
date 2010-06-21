require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  
  test "destroys associated objects" do
    [Name, ContactDetails, Address, User, Event].each{|klass| assert_equal 0, klass.count}    
    client = Client.build!
    [Name, ContactDetails, Address, User, Event].each{|klass| assert_equal 1, klass.count}
    client.destroy    
    [Name, ContactDetails, Address, User, Event].each{|klass| assert_equal 0, klass.count}    
  end
  
end
