class CreateAvailabilities < ActiveRecord::Migration
  def self.up
    create_table :availabilities do |t|
      t.integer :monday, :limit => 3
      t.integer :tuesday, :limit => 3
      t.integer :wednesday, :limit => 3
      t.integer :thursday, :limit => 3
      t.integer :friday, :limit => 3
      t.integer :saturday, :limit => 3
      t.integer :sunday, :limit => 3
      t.timestamps
    end
  end

  def self.down
    drop_table :availabilities
  end
end
