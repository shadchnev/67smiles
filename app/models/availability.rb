class Availability < ActiveRecord::Base
  
  validate :must_be_available_for_at_least_one_day
  
  def must_be_available_for_at_least_one_day
    errors.add_to_base("^Please specify that you are available for at least 8 hours a week") unless days.inject(0) {|sum, day| sum + bits(send(day.to_sym)) } >= 8
  end
  
  def available?(from, to)
    raise "The cleaner cannot be booked overnight" unless from.to_date == to.to_date
    mask = (2**(to.hour - from.hour) - 1) << from.hour
    send(days[from.wday]) & mask == mask
  end
  
  def to_hash
    days.inject({}) {|hash, day| hash.merge({day => send(day) || 0})}
  end  
  
private

  def days
    %w[sunday monday tuesday wednesday thursday friday saturday]
  end
  
  def bits(num)
    (0..23).inject(0) {|count, pos| count + (num ? (num >> pos & 1) : 0)}
  end
  
end
