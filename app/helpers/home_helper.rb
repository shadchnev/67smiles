module HomeHelper
  
  def faq_question(question)
    render :partial => 'faq_item', :locals => {:question => t(question), :answer => t("#{question}_answer".to_sym)}
  end
  
end
