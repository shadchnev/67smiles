class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = {:minimum => 6, :if => :require_password?, :message => "^The password must be 6 characters or more"}
    c.validates_length_of_login_field_options = {:minimum => 6, :if => lambda{|c| false}} # the login is supplied on the server side
    c.validates_format_of_login_field_options = {:with => //, :if => lambda{|c| false}} # so we don't check it at all
    c.validates_length_of_password_confirmation_field_options = {:minimum => 6, :if => lambda {|c| false}}
    c.validates_confirmation_of_password_field_options = {:if => :require_password?, :message => "^Please make sure the password matches the password confirmation field"}
  end
  
  belongs_to :owner, :polymorphic => true
  
  validate :old_password_valid?, :if => Proc.new{|u| 
    !u.new_record? and u.password and !u.password.empty?
  }
  
  def old_password=(val)
    @old_password = val
  end
  
  def old_password
  end
  
  def client?
    owner.kind_of? Client
  end
  
  def cleaner?
    owner.kind_of? Cleaner
  end
  
private

  def old_password_valid?
    errors.add(:old_password, "^Old password is invalid") unless valid_password?(@old_password)
  end
  
end
