class NewCleanerEvent < Event
  
  belongs_to :cleaner

  def visible?
    cleaner.user.active?
  end

end