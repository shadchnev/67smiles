require 'test_helper'

class CleanerSearchTest < ActiveSupport::TestCase
  
  def setup
    Cleaner.build! :postcode => Postcode.build!(:value => 'e1w 3tj', :longitude => -0.0542642, :latitude => 51.5057971), :skills => Skills.build!(:domestic_cleaning => true, :ironing => true)
    Cleaner.build! :postcode => Postcode.build!(:value => 'e1w 2nn', :longitude => -0.0601343, :latitude => 51.5057942), :skills => Skills.build!(:domestic_cleaning => true, :groceries => true)
    Cleaner.build! :postcode => Postcode.build!(:value => 'w21tt',   :longitude => -0.1748254, :latitude => 51.5188202), :availability => Availability.build!(:tuesday => 0b1111111100000000)
    Cleaner.build! :postcode => Postcode.build!(:value => 'nw1 0du', :longitude => -0.1337213, :latitude => 51.5372754)
    Cleaner.build! :postcode => Postcode.build!(:value => 'AB101AA', :longitude => -2.1098230, :latitude => 57.1449345)    
    @origin = Postcode.find_or_create_by_normalized_value('e1w 3tj')    
  end
  
  test "cleaners can be found by postcode" do
    assert_equal 2, Cleaner.find_within(1, :origin => @origin).size
    assert_equal 4, Cleaner.find_within(10, :origin => @origin).size
    assert_equal 5, Cleaner.find_within(500, :origin => @origin).size    
  end
  
  test "suitable cleaners can be found in a vicinity on a specific date" do    
    assert_equal 4, Cleaner.find_suitable!(:origin => @origin, :skills => Skills.build, :date => Date.parse('15-03-2010')).size # Monday
  end
  
  test "suitable cleaners with specific skills are found" do
    assert_equal 1, Cleaner.find_suitable!(:origin => @origin, :skills => Skills.build(:ironing => true), :date => Date.parse('15-03-2010')).size # Monday
  end
  
  test "exception is raised if no suitable cleaners are found" do
    assert_raise RuntimeError do
      Cleaner.find_suitable!(:origin => @origin, :skills => Skills.build(:ironing => true), :date => Date.parse('16-03-2010')).size # Tuesday
    end
  end
  
  test "suitable cleaners are filtered by date" do
    assert_equal 1, Cleaner.find_suitable!(:origin => @origin, :skills => Skills.build, :date => Date.parse('16-03-2010')).size # Tuesday
  end
    
end