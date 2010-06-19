class CreatePhoneConfirmationCodes < ActiveRecord::Migration
  def self.up
    create_table :phone_confirmation_codes do |t|
      t.string :phone, :limit => 12
      t.string :value, :limit => 4
    end
  end

  def self.down
    drop_table :phone_confirmation_codes
  end
end
