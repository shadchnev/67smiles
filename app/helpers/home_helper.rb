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
  
end
