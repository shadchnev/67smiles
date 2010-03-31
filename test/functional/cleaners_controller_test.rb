require 'test_helper'

class CleanersControllerTest < ActionController::TestCase
    
  test "postcode isn't recreated if exists" do     
    postcode = Postcode.build!(:value => 'e1w 3tj')    
    xhr :post, :create, new_cleaner_params
    assert_equal postcode.id, Cleaner.first.postcode.id
  end
  
private

  def new_cleaner_params
    {"cleaner" => 
      {"minimum_hire"=>"4", 
       "name_attributes" => 
       {"honorific"=>"Ms", 
        "last_name"=>"Cameron", 
        "first_name"=>"Emma"}, 
       "user_attributes"=>
        {"password_confirmation"=>"[FILTERED]", 
         "password"=>"[FILTERED]"}, 
         "postcode_attributes"=>
          {"value"=>"e1w 3tj"}, 
         "terms_and_conditions"=>"1", 
         "rate"=>"10", 
         "availability_attributes"=>
          {"friday"=>"4194176", 
           "tuesday"=>"4194176", 
           "wednesday"=>"4194176", 
           "monday"=>"4194176", 
           "saturday"=>"0", 
           "sunday"=>"0", 
           "thursday"=>"4194176"}, 
         "surcharge"=>"2", 
         "description"=>"blaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaah", 
         "contact_details_attributes"=>
          {"phone"=>"07912345678", "email"=>"emma@mail.com"}, 
         "skills_attributes"=>
          {"pets"=>"0", 
           "groceries"=>"0", 
           "ironing"=>"0", 
           "domestic_cleaning"=>"1"}}}
  end
  
end
