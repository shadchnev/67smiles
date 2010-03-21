require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  
  test "postcode isn't recreated if exists" do     
    postcode = Postcode.build!(:value => 'e1w 3tj')    
    xhr :post, :create, new_client_params
    assert_equal postcode.id, Client.first.address.postcode.id
  end
  
private

  def new_client_params
    {"client" => 
      {"name_attributes" => 
        {"honorific" => "Ms",
         "last_name" => "Cameron", 
         "first_name"=>"Emma"}, 
       "user_attributes" => 
        {"password_confirmation"=>"[FILTERED]", 
         "password"=>"[FILTERED]"}, 
       "terms_and_conditions"=>"1", 
       "address_attributes" => 
        {"city" => "London",
         "third_line" => "", 
         "postcode_attributes" => 
          {"value" => "E1W 3TJ"}, 
         "first_line" => "60 Prospect Place", 
         "second_line" => "Wapping Wall"}, 
       "contact_details_attributes" => 
        {"phone" => "07912345678", 
          "email" => "test@test.com"}}, 
    }    
  end
  
end