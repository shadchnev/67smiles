class AddEmailConfirmedToContactDetails < ActiveRecord::Migration
  def self.up
    add_column :contact_details, :email_confirmed, :boolean
  end

  def self.down
    remove_column :contact_details, :email_confirmed
  end
end
