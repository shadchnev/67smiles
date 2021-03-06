module ClientHelper
  
  def client_modification_title(action)
    return 'Create a new account' if action == "new" or action == 'create'
    'Update your account' if action == "edit" or action == 'update'
  end
  
  def client_modification_submit(action, booking)
    return 'Save My Profile' if action == "edit" or action == 'update'
    title = 'Create My Account' if action == "new" or action == 'create'
    booking ? title += " and Book #{booking.cleaner.first_name}" : title
  end
  
  def client_modification_subtitle(action, after_login_path)
    "You need to create an account to get your home cleaned. #{link_to 'Already registered?', '#', :onclick => 'showLoginPrompt("", "' + after_login_path + '")'}" if action == "new" or action == 'create'
  end
  
end
