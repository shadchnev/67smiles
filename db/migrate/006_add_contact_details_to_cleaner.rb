class AddContactDetailsToCleaner < ActiveRecord::Migration
  def self.up
    add_column :cleaners, :contact_details_id, :integer
  end

  def self.down
    remove_column :cleaners, :contact_details_id
  end
end
