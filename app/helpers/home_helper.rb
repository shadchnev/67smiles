module HomeHelper
  
  def faq_question(question)
    render :partial => 'faq_item', :locals => {:question => t(question), :answer => t("#{question}_answer".to_sym), :anchor => question}
  end
  
  def day_of_week(cleaner, day)
    short = {
      :monday => 'Mon',
      :tuesday => 'Tue',
      :wednesday => 'Wed',
      :thursday => 'Thu',
      :friday => 'Fri',
      :saturday => 'Sat',
      :sunday => 'Sun'
    }
    "<div class=\"day-of-week #{cleaner.available_on?(day) ? 'active' : 'inactive'}\">#{short[day]}</div>"
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
    else email.split("@").last
    end
  end
  
end
