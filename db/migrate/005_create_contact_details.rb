class CreateContactDetails < ActiveRecord::Migration
  def self.up
    create_table :contact_details do |t|
      t.string :email
      t.string :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_details
  end
end
