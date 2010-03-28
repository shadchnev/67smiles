require 'test_helper'

class SmsTest < ActiveSupport::TestCase
  
  test "can send messages" do    
    sms = Sms.new do |s|
      s.text = 'test'
      s.to = '447923374199'
    end
    sms.stubs(:update_state).returns(true)
    sms.save!
    sms.stubs(:curl).returns(curl)
    silence_warnings {Sms.const_set('GATEWAY_ERROR', nil)} # we pretend we're production in this respect since we're stubbing curl with a production reply
    assert sms.send :dispatch
  end

private
  
  def curl
    curl = mock('curl')
    curl.responds_like Curl::Easy.new(Sms::GATEWAY_API)
    curl.stubs(:http_post)                    
    curl.stubs(:body_str).returns('{"TestMode":0,"MessageReceived":"test","Custom":"13","MessageCount":1,"From":"InncntClnrs","CreditsAvailable":"9","MessageLength":1,"NumberContacts":1,"CreditsRequired":1,"CreditsRemaining":8}')
    curl    
  end
  
end
