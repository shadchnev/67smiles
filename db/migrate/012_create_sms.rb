class CreateSms < ActiveRecord::Migration
  def self.up
    create_table :sms do |t|
      t.string :from, :limit => 12
      t.string :to, :limit => 12
      t.string :text, :limit => 612 # 612 is the length of 4 sms
      t.string :state, :limit => 1 # just one letter should be enough to encode the status
      t.integer :booking_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sms
  end
end
