# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def round_if_possible(value)    
    ((value - value.round).abs < 0.1 ? value.round.to_i : value) if value
  end
  
  def university(email)
    case email
    when /ic.ac.uk$/; 'Imperial College London'
    when /imperial.ac.uk$/; "Imperial College London"      
    when /westminster.ac.uk$/; 'Westminster University'
    when /marjon.ac.uk$/; 'University College Marjon'
    when /londonmet.ac.uk$/; 'London Metropolitan University'
    when /ucl.ac.uk$/; 'University College London'
    when /bournemouth.ac.uk$/; 'Bournemouth University'
    when /live.mdx.ac.uk$/; 'Middlesex University'
    when /csm.arts.ac.uk$/; 'Central Saint Martins University of the Arts'
    when /\bchester.ac.uk$/; 'University of Chester'
    when /manchester.ac.uk$/; 'University of Manchester'
    when /heythrop.ac.uk$/; 'Heythrop College'
    when /heythropcollege.ac.uk$/; 'Heythrop College'
    when /open.ac.uk$/; 'Open University'
    when /qmul.ac.uk$/; 'Queen Mary, University of London'
    when /kent.ac.uk$/; 'University of Kent'
    when /soas.ac.uk$/; 'School of Oriental and African Studies, University of London'
    when /bcu.ac.uk$/; 'Birmingham City University'
    when /uel.ac.uk$/; 'University of East London'
    when /edgehill.ac.uk$/; 'Edge Hill University'
    when /rgu.ac.uk$/; 'Robert Gordon University'
    when /anglia.ac.uk$/; 'Anglia Ruskin University'
    when /ljmu.ac.uk$/; 'Liverpool John Moores University'
    when /uclan.ac.uk$/; 'University of Central Lancashire'
    when /kcl.ac.uk$/; 'King\'s College London'
    when /herts.ac.uk$/; 'University of Hertfordshire'
    when /caledonian.ac.uk$/; 'Glasgow Caledonian University'
    when /city.ac.uk$/; 'City University London'
    when /aberdeen.ac.uk$/; 'University of Aberdeen'
    else email.split("@").last
    end
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
    cleaner.completed_jobs.empty? ? "" : "#{pluralize(cleaner.completed_jobs.size, 'job')} done"
  end
  
  def booking_status(booking)
    return "Missed by the cleaner" if booking.missed?
    return 'Cancelled' if booking.cancelled?
    return 'Declined' if booking.declined?
    return 'Not accepted yet' unless booking.accepted?
    return 'Accepted' if booking.accepted?
  end  
  
end
