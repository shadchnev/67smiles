class Availability < ActiveRecord::Base
  
  validate :must_be_available_for_at_least_one_day
  
  def must_be_available_for_at_least_one_day
    errors.add_to_base("Please specify that you are available for at least 8 hours a week") unless %w[monday tuesday wednesday thursday friday saturday sunday].inject(0) {|sum, day| sum + bits(send(day.to_sym)) } >= 8
  end
  
private
  
  def bits(num)
    (0..23).inject(0) {|count, pos| count + (num ? (num >> pos & 1) : 0)}
  end
  
end
