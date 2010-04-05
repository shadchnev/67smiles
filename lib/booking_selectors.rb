module BookingSelectors
  
  def upcoming_bookings
    bookings.select{|b| b.start_time >= Time.now}
  end
  
  def past_bookings
    bookings.select{|b| b.start_time < Time.now}
  end  
  
end