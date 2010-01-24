class CreateNames < ActiveRecord::Migration
  def self.up
    create_table :names do |t|
      t.string :honorific
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end

  def self.down
    drop_table :names
  end
end
