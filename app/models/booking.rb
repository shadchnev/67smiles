class Booking < ActiveRecord::Base
  
  belongs_to :cleaner
  belongs_to :client
  
  has_many :sms
  
  validates_associated :cleaner
  validates_associated :client
  validates_presence_of :cleaner
  validates_presence_of :client
  
  validate :time_valid?
  validate :time_available?, :if => Proc.new{|b| b.errors.on_base.nil? and b.cleaner }
  
  before_create :calculate_cost
  
  CANCELLATION_DEADLINE = 1.hour
  
  def time_valid?
    errors.add_to_base("The booking time is invalid") unless start_time and end_time and start_time.to_date == end_time.to_date and start_time.hour < end_time.hour
  end
  
  def time_available?
    errors.add_to_base("#{cleaner.first_name} is not available for hire at the specified time") unless cleaner.available?(start_time, end_time)
  end
  
  def ask_cleaner!
    send_text(cleaner, SmsContent.booking_enquiry(self))
  end
  
  def self.first_pending_for(number)
    return unless cleaner = Cleaner.find_by_phone(number)
    find :first, :conditions => ["cleaner_id = ? AND accepted IS NULL AND created_at > ?", cleaner.id, expired_cutoff], :order => 'created_at ASC'
  end
  
  def accept!
    self.accepted = true
    send_text(client, SmsContent.booking_accepted(self))
    save!
  end
  
  def decline!
    self.accepted = false
    send_text(client, SmsContent.booking_declined(self))
    save!
  end
  
  def cancel!
    self.cancelled = true
    save!
  end
  
  def address
    client.address
  end
  
  def day
    start_time.to_date
  end
  
  def declined?
    accepted == false
  end
  
  def accepted?
    accepted == true
  end
  
  def cancelled?
    cancelled == true
  end
  
  # can still be cancelled
  def cancellable?
    !cancelled? and !missed? and (start_time - Time.now) > CANCELLATION_DEADLINE
  end
  
  def pending?
    !accepted? and !declined? and !missed?
  end
  
  def missed?
    return false unless accepted.nil?
    (Time.now - created_at) > CLEANER_REPLY_TIMEOUT
  end
  
  def time_left
    difference = created_at + CLEANER_REPLY_TIMEOUT - Time.now
    difference > 0 ? difference : 0
  end
  
  def completed?
    accepted? and !cancelled? and end_time < Time.now
  end
  
  def to_partial_hash
    {
      :cleaning_materials_provided => cleaning_materials_provided,
      :start_time => start_time.to_s,
      :end_time => end_time.to_s,
      :cleaner_id => cleaner.id
    }
  end
  
private

  def send_text(recipient, text)
    sms = Sms.create do |s|
      s.to = recipient.phone
      s.text = text
    end        
    sms.dispatch or raise("Sorry, I couldn't send a text message. Recipient is a #{recipient.class.to_s} with id #{recipient ? recipient.id : 'n/a'}. Text: #{text}")
    self.sms << sms      
  end

  def calculate_cost
    self[:cost] = number_of_hours * (cleaner.rate + surcharge)
  end

  def self.expired_cutoff
    (Time.now.utc - CLEANER_REPLY_TIMEOUT).to_s :db
  end

  def number_of_hours
    end_time.hour - start_time.hour
  end

  def surcharge
    cleaning_materials_provided? ? 0 : cleaner.surcharge
  end

end
