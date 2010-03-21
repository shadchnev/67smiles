# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def round_if_possible(value)    
    ((value - value.round).abs < 0.1 ? value.round.to_i : value) if value
  end
  
  def navigational_link(key)
    case key
    when :about then link_to "About", "/about"
    when :register then link_to "Register", '#', :onclick => "selectRegistrationType(); return false;"
    when :login then link_to "Login", '#', :onclick => "showLoginPrompt(); return false;"    
    when :logout then link_to "Logout", user_sessions_path, :method => :delete
    end
  end  
  
  def navigation_elements
    elements = [:about]
    elements += current_user ? [:logout] : [:register, :login] 
    elements
  end
  
end
