module CleanerHelper
  
  def session_key_name
    ActionController::Base.session_options[:key]
  end
  
  def modification_title(action)
    "Join Innocent Cleaners" if action == 'new'
    "Edit your profile" if action == 'edit' or action == 'update'
  end
  
  def modification_subtitle(action)
    "You're just 60 seconds away from being available for hire on Innocent Cleaners!" if action == 'new'
  end
  
  def modification_submit(action)
    "Join Innocent Cleaners" if action == 'new'
    "Update your profile" if action == 'edit' or action == 'update'    
  end
  
end
