require 'test_helper'

class ContactDetailsTest < ActiveSupport::TestCase
  
  test "validates the format of the phone number" do
    assert ContactDetails.build(:phone => '07923374199').valid?
    assert !ContactDetails.build(:phone => '7923374199').valid?
    assert ContactDetails.build(:phone => '+44 79 233 74 199').valid?
    assert ContactDetails.build(:phone => '079 233 74 199').valid?
    assert ContactDetails.build(:phone => '075 233 74 199').valid?
    assert ContactDetails.build(:phone => '076 243 74 199').valid?
    assert !ContactDetails.build(:phone => '076 253 74 199').valid?
    assert ContactDetails.build(:phone => '077 253 74 199').valid?
    assert ContactDetails.build(:phone => '078 253 74 199').valid?
    assert ContactDetails.build(:phone => '079 253 74 199').valid?
    assert !ContactDetails.build(:phone => '070 253 74 199').valid?
    assert !ContactDetails.build(:phone => '079 253 74 19').valid?
    assert !ContactDetails.build(:phone => '0792537419').valid?
    assert !ContactDetails.build(:phone => '0207121 1199').valid?
    assert !ContactDetails.build(:phone => '+44207121 1199').valid?
    assert ContactDetails.build(:phone => '+44(0)79 2337 4199').valid?
    assert ContactDetails.build(:phone => '44(0)79 2337 4199').valid?
    assert ContactDetails.build(:phone => '44 (0) 79 2337 4199').valid?
  end
end
