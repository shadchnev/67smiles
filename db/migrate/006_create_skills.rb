class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.boolean :domestic_cleaning
      t.boolean :ironing
      t.boolean :groceries
      t.boolean :pets
      t.timestamps
    end
  end

  def self.down
    drop_table :skills
  end
end
