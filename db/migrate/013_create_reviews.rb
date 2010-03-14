class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :cleaner_id
      t.integer :client_id
      t.text :text
      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
