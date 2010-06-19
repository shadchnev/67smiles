require 'test_helper'

class UserControllerTest < ActionController::TestCase
  
  test "confirm email" do
    client = Client.build!
    assert !client.user.email_confirmed?
    get :confirm_email, :activation_code => client.user.perishable_token
    assert client.reload.user.email_confirmed?
  end
  
  test "do not confirm email with wrong code" do
    client = Client.build!
    assert !client.user.email_confirmed?
    get :confirm_email, :activation_code => 'bad code'
    assert !client.reload.user.email_confirmed?
  end
  
  test "activate" do
    cleaner = Cleaner.build!
    cleaner.user.active = false
    cleaner.user.save!
    get :activate, :activation_code => cleaner.user.perishable_token
    assert cleaner.reload.user.active?
  end
  
  test "do not activate with wrong code" do
    cleaner = Cleaner.build!
    cleaner.user.active = false
    cleaner.user.save!
    get :activate, :activation_code => 'bad code'
    assert !cleaner.reload.user.active?
  end  
  
end
