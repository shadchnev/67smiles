class CreateSms < ActiveRecord::Migration
  def self.up
    create_table :sms do |t|
      t.integer :from
      t.integer :to
      t.string :text, :limit => 612 # 612 is the length of 4 sms
      t.string :status, :limit => 1 # just one letter should be enough to encode the status
      t.integer :booking_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sms
  end
end
