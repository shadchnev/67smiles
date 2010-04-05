module ClientHelper
  
  def client_modification_title(action)
    'Create a new account' if action == "new"
    'Update your account' if action == "edit"
  end
  
  def client_modification_submit(action)
    'Create an account' if action == "new"
    'Update your account' if action == "edit"
  end
  
  def client_modification_subtitle(action)
    'You need to create an account to get your home cleaned.' if action == "new"
  end
  
end
