require 'test_helper'

class PostcodeTest < ActiveSupport::TestCase
  
  test "postcodes are auto-geocoded" do
    p = Postcode.create!(:value => 'E1W 3TJ') # this hits google even in test env
    assert_equal 51.5057971, p.latitude
    assert_equal -0.0542642, p.longitude
  end
 
  test "invalid postcodes cannot be created" do
    assert !Postcode.new(:value => 'r1265r').valid?    
    assert !Postcode.new(:value => 'n1rdu').valid?    
    assert !Postcode.new(:value => '').valid?    
    assert !Postcode.new(:value => nil).valid?    
  end
  
  test "valid postcodes can be created" do
    assert Postcode.new(:value => 'w21tt').valid?    
    assert Postcode.new(:value => 'GIR 0AA').valid?    
    assert Postcode.new(:value => 'w2 1tt').valid?    
  end
  
  test "postcode knows its area" do
    assert_equal 'E1W',  Postcode.build(:value => 'e1w3tj').area    
    assert_equal 'NW3',  Postcode.build(:value => 'nw36nd').area
    assert_equal 'GIR',  Postcode.build(:value => 'GIR0AA').area    
    assert_equal 'W2',   Postcode.build(:value => 'w21tt').area    
    assert_equal 'SE14', Postcode.build(:value => 'se145DN').area    
  end
  
end
