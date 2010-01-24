class AddPostcodeToCleaner < ActiveRecord::Migration
  def self.up
    add_column :cleaners, :postcode_id, :integer
  end

  def self.down
    remove_column :cleaners, :postcode_id
  end
end
