require 'test_helper'

class SmsControllerTest < ActionController::TestCase
  
  def setup    
    @request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Basic.encode_credentials(SmsController::USER_ID, SmsController::PASSWORD)
  end
  
  test "can receive incoming sms" do
    post :create, {'sender' => '447923374199', 'content' => 'yes', 'inNumber' => '447786201825'}
    assert sms = Sms.first
    assert_equal 'yes', sms.text
    assert_equal '447786201825', sms.to
    assert_equal '447923374199', sms.from
    assert sms.incoming?
  end
  
  test "gets delivery reports" do
    sms = Sms.build!
    post :update, {:id => sms.id, 'number' => sms.to, 'status' => 'D'}
    assert sms.reload.delivered?
  end
  
  test "gets invalid reports" do
    sms = Sms.build!
    post :update, {:id => sms.id, 'number' => sms.to, 'status' => 'I'}
    assert sms.reload.invalid?
  end
  
  test "gets undelivered reports" do
    sms = Sms.build!
    post :update, {:id => sms.id, 'number' => sms.to, 'status' => 'U'}
    assert sms.reload.undelivered?
  end
  
  test "fails on bad status reports" do
    sms = Sms.build!
    assert_raise RuntimeError do
      post :update, {:id => sms.id, 'number' => sms.to, 'status' => 'A'}      
    end
  end
  
  test "fails if the mobile number is unrecognized" do
    sms = Sms.build!
    assert_raise RuntimeError do
      post :update, {:id => sms.id, 'number' => '447123456789', 'status' => 'D'}
    end
  end
  
end
