# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def round_if_possible(value)    
    ((value - value.round).abs < 0.1 ? value.round.to_i : value) if value
  end
  
  def navigational_link(key)
    case key
    when :about               then link_to "About", "/about"
    when :register            then link_to "Register", '#', :onclick => "selectRegistrationType(); return false;"
    when :login               then link_to "Login", '#', :onclick => "showLoginPrompt(); return false;"    
    when :logout              then link_to "Logout", user_sessions_path, :method => :delete
    when :cleaners_bookings   then link_to "My Jobs", cleaner_bookings_path(current_user.owner)
    when :clients_bookings    then link_to "Bookings", "/clients/#{current_user.owner.id}/bookings"
    when :edit_client         then link_to "Edit Profile", edit_client_path(current_user.owner)
    when :edit_cleaner        then link_to "Edit Profile", edit_cleaner_path(current_user.owner)
    when :faq                 then link_to "FAQ", '/faq'
    end
  end  
  
  def navigation_elements
    elements = [:faq]
    elements += [:cleaners_bookings, :edit_cleaner] if current_user and current_user.cleaner?
    elements += [:clients_bookings, :edit_client]  if current_user and current_user.client?
    elements += current_user ? [:logout] : [:register, :login] 
    elements
  end
  
  def jobs_done(cleaner)
    cleaner.completed_jobs.empty? ? "Never been hired before" : "#{cleaner.completed_jobs.size} jobs done"
  end
  
  def booking_status(booking)
    return "Missed by the cleaner" if booking.missed?
    return 'Cancelled' if booking.cancelled?
    return 'Declined' if booking.declined?
    return 'Not accepted yet' unless booking.accepted?
    return 'Accepted' if booking.accepted?
  end  
  
end
