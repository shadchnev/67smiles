# Understands how to process sms messages
class Sms < ActiveRecord::Base
  
  SENT_STATE = 'S'
  UNSENT_STATE = 'F'
  DELIVERED_STATE = 'D'
  INVALID_STATE = 'I' 
  UNDELIVERED_STATE = 'U'
  GATEWAY_API = 'http://www.txtlocal.com/sendsmspost.php'
  FROM_ID = 'InncntClnrs'
  USERNAME = 'evgeny.shadchnev@gmail.com'
  PASSWORD = '67mops!'
  
  belongs_to :booking
  
  validates_presence_of :to
  validates_presence_of :text
  
  validates_format_of :to, :with => /^447\d{9}$/
  
  after_create :update_state
  
  def sent?
    status != UNSENT_STATE # sent? may also mean delivered, undelivered etc.
  end
  
  def delivered?
    status == DELIVERED_STATE
  end
  
private

  def update_state
    self.update_attributes!(:status => dispatch ? SENT_STATE : UNSENT_STATE)
  end
  
  def dispatch    
    curl.http_post(*post_fields)
    success? curl.body_str
  end
  
  def post_fields
    [ f('json', 1),
      f('test', GATEWAY_TEST_MODE),
      f('message', text),
      f('from', FROM_ID),
      f('uname', USERNAME),
      f('pword', PASSWORD),
      f('selectednums', to),
      f('custom', id)]
  end
    
  def f(name, content)
    Curl::PostField.content(name, content)
  end
  
  def curl
    @curl ||= Curl::Easy.new(GATEWAY_API)    
  end
  
  def success?(reply)
    return false unless reply
    parsed_reply = JSON.parse reply
    parsed_reply['Error'] == GATEWAY_ERROR and parsed_reply['MessageReceived'] == text
  end

end
