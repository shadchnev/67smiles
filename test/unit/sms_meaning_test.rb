require 'test_helper'

class SmsMeaningTest < ActiveSupport::TestCase
  
  test "can understand valid reply yes" do
    assert SmsMeaning.new('Yes!').accepted?
    assert SmsMeaning.new('yes').accepted?
    assert SmsMeaning.new('yes :)').accepted?
    assert SmsMeaning.new('yes, thanks!').accepted?
  end

  test "can understand valid reply no" do
    assert !SmsMeaning.new('no').accepted?
    assert !SmsMeaning.new('No').accepted?
    assert !SmsMeaning.new('No, thanks!').accepted?
    assert !SmsMeaning.new('No!').accepted?
  end

end
