module CleanerHelper
  
  def session_key_name
    ActionController::Base.session_options[:key]
  end
  
end
