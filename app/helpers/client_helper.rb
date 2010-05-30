module ClientHelper
  
  def client_modification_title(action)
    return 'Create a new account' if action == "new"
    'Update your account' if action == "edit" or action == 'update'
  end
  
  def client_modification_submit(action)
    return 'Create My Account' if action == "new"
    'Save My Profile' if action == "edit" or action == 'update'
  end
  
  def client_modification_subtitle(action)
    'You need to create an account to get your home cleaned.' if action == "new"
  end
  
end
