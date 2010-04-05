# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 12) do

  create_table "addresses", :force => true do |t|
    t.string   "first_line"
    t.string   "second_line"
    t.string   "third_line"
    t.string   "city"
    t.integer  "postcode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "availabilities", :force => true do |t|
    t.integer  "monday",     :limit => 3
    t.integer  "tuesday",    :limit => 3
    t.integer  "wednesday",  :limit => 3
    t.integer  "thursday",   :limit => 3
    t.integer  "friday",     :limit => 3
    t.integer  "saturday",   :limit => 3
    t.integer  "sunday",     :limit => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.integer  "cleaner_id"
    t.integer  "client_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "cleaning_materials_provided"
    t.boolean  "accepted"
    t.boolean  "cancelled"
    t.decimal  "cost",                        :precision => 4, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cleaners", :force => true do |t|
    t.integer  "name_id"
    t.text     "description"
    t.integer  "minimum_hire"
    t.decimal  "rate",               :precision => 4, :scale => 2
    t.decimal  "surcharge",          :precision => 4, :scale => 2
    t.integer  "availability_id"
    t.integer  "skills_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "contact_details_id"
    t.integer  "postcode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.integer  "address_id"
    t.integer  "name_id"
    t.integer  "contact_details_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_details", :force => true do |t|
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_details", ["email"], :name => "index_contact_details_on_email", :unique => true
  add_index "contact_details", ["phone"], :name => "index_contact_details_on_phone", :unique => true

  create_table "names", :force => true do |t|
    t.string   "honorific"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postcodes", :force => true do |t|
    t.string   "value"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "postcodes", ["latitude", "longitude"], :name => "index_postcodes_on_latitude_and_longitude"
  add_index "postcodes", ["value"], :name => "index_postcodes_on_value", :unique => true

  create_table "reviews", :force => true do |t|
    t.integer  "cleaner_id"
    t.integer  "client_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.boolean  "domestic_cleaning"
    t.boolean  "ironing"
    t.boolean  "groceries"
    t.boolean  "pets"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms", :force => true do |t|
    t.string   "from",       :limit => 12
    t.string   "to",         :limit => 12
    t.string   "text",       :limit => 612
    t.string   "state",      :limit => 1
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "login_count",       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
