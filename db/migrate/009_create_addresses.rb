class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string   :first_line
      t.string   :second_line
      t.string   :third_line
      t.string   :city
      t.integer  :postcode_id      
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
