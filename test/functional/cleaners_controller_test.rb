require 'test_helper'

class CleanersControllerTest < ActionController::TestCase
    
  test "postcode isn't recreated if exists" do     
    postcode = Postcode.build!(:value => 'e1w 3tj')    
    post :create, new_cleaner_params
    assert_equal postcode.id, Cleaner.first.postcode.id
    assert_equal 10, Cleaner.first.rate
  end
  
  test "availability can be updated" do
    cleaner = Cleaner.build!
    assert !cleaner.available_on?(:friday)
    assert !cleaner.skills.pets?
    put :update, updated_cleaner_params(cleaner)
    assert_redirected_to cleaner_path(cleaner)
    cleaner.reload
    assert cleaner.skills.pets?
    assert cleaner.available_on?(:friday)    
  end
  
private

  def updated_cleaner_params(cleaner)
    {"cleaner"=>
      {"name_attributes"=>
          {"honorific"=>"Ms", 
            "first_name"=>"Emma", 
            "last_name"=>"BROWN", 
            "id"=>cleaner.name.id}, 
      "postcode_attributes"=>
        {"value"=>"E1W 3TJ", 
          "id"=>cleaner.postcode.id}, 
      "contact_details_attributes"=>
        {"email"=>"emma@ic.ac.uk", 
          "phone"=>"447923374199", 
          "id"=>cleaner.contact_details.id}, 
      "description"=>"I'm the best cleaner ever! Really :)", 
      "skills_attributes"=>
        {"domestic_cleaning"=>"1", 
          "ironing"=>"0", 
          "groceries"=>"0", 
          "pets"=>"1", 
          "id"=>cleaner.skills.id}, 
      "minimum_hire"=>"1", 
      "rate"=>"10 (hourly rate)", 
      "surcharge"=>"1 (cleaning materials surcharge)", 
      "availability_attributes"=>
        {"monday"=>"130944", "tuesday"=>"130944", "wednesday"=>"130944", "thursday"=>"130944", "friday"=>"130944", "saturday"=>"0", "sunday"=>"0", "id" => cleaner.availability.id}, 
        "user_attributes"=>
          {"password"=>"", 
            "password_confirmation"=>"", 
            "old_password"=>"", 
            "id"=>cleaner.user.id}}, 
      "commit"=>"Update your profile", 
      "controller"=>"cleaners", 
      "action"=>"update", 
      "id"=>cleaner.id}    
  end

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
         "rate"=>"pounds 10", 
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
          {"phone"=>"07912345678", "email"=>"emma@ic.ac.uk"}, 
         "skills_attributes"=>
          {"pets"=>"0", 
           "groceries"=>"0", 
           "ironing"=>"0", 
           "domestic_cleaning"=>"1"}}}
  end
  
end
