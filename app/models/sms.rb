# Understands how to process sms messages
class Sms < ActiveRecord::Base
  
  SENT_STATE = 'S'
  UNSENT_STATE = 'F'
  DELIVERED_STATE = 'D'
  INVALID_STATE = 'I' 
  UNDELIVERED_STATE = 'U'
  INCOMING_STATE = 'R' # I don't want to use self.to == own_number because the inbound number may change in the future
  GATEWAY_URL = 'http://www.txtlocal.com/sendsmspost.php'
  FROM_ID = 'InncntClnrs'
  USERNAME = 'evgeny.shadchnev@gmail.com'
  PASSWORD = '67mops!'
  OWN_NUMBER = '447786202240'
  
  belongs_to :booking
  
  validates_presence_of :to
  validates_presence_of :from
  validates_presence_of :text
  
  validates_format_of :to, :with => /^447\d{9}$/
  validates_format_of :from, :with => /^447\d{9}$/
  
  def sent?
    outgoing? and state != UNSENT_STATE # sent? may also mean delivered, undelivered etc.
  end
  
  def delivered?
    state == DELIVERED_STATE
  end
  
  def invalid?
    state == INVALID_STATE
  end
  
  def undelivered?
    state = UNDELIVERED_STATE
  end
  
  def to=(number)
    number == OWN_NUMBER ? inbound! : outbound!
    self[:to] = number
  end
  
  def from=(number)
    self[:from] = number
  end
  
  def dispatch    
    curl.http_post(*post_fields)
    success? curl.body_str
  end
  
  def outgoing?    
    state != INCOMING_STATE
  end
  
  def incoming?
    state == INCOMING_STATE
  end
  
  def addressee?(number)
    to == number
  end
  
  def delivered!
    self.state = DELIVERED_STATE
  end
  
  def undelivered!
    self.state = UNDELIVERED_STATE
  end
  
  def invalid!
    self.state = INVALID_STATE
  end
  
  def before_create
    incoming? ? process_incoming : true
  end
  
private

  def process_incoming
    self.booking, meaning = Booking.first_pending_for(self.from), SmsMeaning.new(self.text)
    meaning.accepted? ? self.booking.accept! : self.booking.decline! if self.booking and meaning.understood?
    true
  end

  def inbound!    
    self.state = INCOMING_STATE
  end
  
  def outbound!
    self.from ||= OWN_NUMBER
    self.state = UNSENT_STATE
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
    @curl ||= Curl::Easy.new(GATEWAY_URL)    
  end
  
  def success?(reply)
    return false unless reply
    parsed_reply = JSON.parse reply
    parsed_reply['Error'] == GATEWAY_NO_ERROR and parsed_reply['MessageReceived'] == text
  end

end
