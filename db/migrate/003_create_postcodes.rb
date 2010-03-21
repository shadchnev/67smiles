class CreatePostcodes < ActiveRecord::Migration
  def self.up
    create_table :postcodes do |t|
      t.string :value
      t.float :longitude
      t.float :latitude
      t.timestamps
    end
    
    change_table :postcodes do |t|
      t.index [:latitude, :longitude]
      t.index :value, :unique => true
    end
  end

  def self.down
    drop_table :postcodes
  end
end
