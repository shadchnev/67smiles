require 'test_helper'

class SmsTest < ActiveSupport::TestCase
  
  def setup
    silence_warnings {Sms.const_set('GATEWAY_NO_ERROR', nil)} # we pretend we're production in this respect since we're stubbing curl with a production reply    
  end
  
  test "can send messages" do    
    sms = Sms.new do |s|
      s.text = 'test'
      s.to = '447923374199'
    end
    sms.stubs(:update_state).returns(true)
    sms.save!
    sms.stubs(:curl).returns(curl('test'))
    test_value = Sms.const_get('GATEWAY_NO_ERROR')
    assert sms.send :dispatch
    assert sms.outgoing?
  end
  
  test "incoming messages are processed (yes)" do
    booking = Booking.build!        
    Sms.any_instance.stubs(:curl).returns(curl(SmsContent.booking_accepted(booking)))
    receive_sms!(booking.cleaner.phone, 'Yes!!!')
    assert booking.reload.accepted?
  end

  test "incoming messages are processed (no)" do
    booking = Booking.build!
    Sms.any_instance.stubs(:curl).returns(curl(SmsContent.booking_declined(booking)))
    receive_sms!(booking.cleaner.phone, 'no, sorry')
    assert !booking.reload.accepted?
    assert booking.declined?
  end

private

  def receive_sms!(from, text)
    Sms.create do |s|
      s.text = text
      s.to = Sms::OWN_NUMBER
      s.from = from
    end
  end
  
  def curl(text)
    curl = mock('curl')
    curl.responds_like Curl::Easy.new(Sms::GATEWAY_URL)
    curl.stubs(:http_post)                    
    curl.stubs(:body_str).returns('{"TestMode":0,"MessageReceived":"' + text + '","Custom":"13","MessageCount":1,"From":"InncntClnrs","CreditsAvailable":"9","MessageLength":1,"NumberContacts":1,"CreditsRequired":1,"CreditsRemaining":8}')
    curl    
  end
  
end
