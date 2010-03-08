class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.integer :address_id
      t.integer :name_id
      t.integer :contact_details_id
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
