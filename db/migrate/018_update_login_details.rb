class UpdateLoginDetails < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
      user.login = user.owner.contact_details.phone
      user.save!
    end
  end

  def self.down
    User.all.each do |user|
      user.login = user.owner.contact_details.email
      user.save!
    end    
  end
end
