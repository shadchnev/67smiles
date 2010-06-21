require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  
  test "destroys associated objects" do
    [Name, ContactDetails, Address, User, Event].each{|klass| assert_equal 0, klass.count}    
    client = Client.build!
    [Name, ContactDetails, Address, User, Event].each{|klass| assert_equal 1, klass.count}
    client.destroy    
    [Name, ContactDetails, Address, User, Event].each{|klass| assert_equal 0, klass.count}    
  end
  
  test "creates the event" do
    assert_equal 0, NewClientEvent.count
    client = Client.build!
    assert_equal 1, NewClientEvent.count
    assert_equal client, NewClientEvent.first.client
  end
  
end
