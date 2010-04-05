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
    when :clients_bookings    then link_to "Bookings", "/client/#{current_user.owner.id}/bookings"
    when :edit_client         then link_to "Edit Profile", edit_client_path(current_user.owner)
    when :edit_cleaner        then link_to "Edit Profile", edit_cleaner_path(current_user.owner)
    end
  end  
  
  def navigation_elements
    elements = []
    elements += [:cleaners_bookings, :edit_cleaner] if current_user and current_user.cleaner?
    elements += [:clients_bookings, :edit_client]  if current_user and current_user.client?
    elements += current_user ? [:logout] : [:register, :login] 
    elements
  end
  
end
