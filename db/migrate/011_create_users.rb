class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      
      t.integer :owner_id
      t.string :owner_type
      t.timestamps
    end
    change_table :users do |t|
      t.index :login, :unique => true
      t.index :persistence_token
      t.index :last_request_at
    end
  end

  def self.down
    drop_table :users
  end
end
