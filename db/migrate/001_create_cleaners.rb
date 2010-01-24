class CreateCleaners < ActiveRecord::Migration
  def self.up
    create_table :cleaners do |t|
      t.integer :name_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cleaners
  end
end
