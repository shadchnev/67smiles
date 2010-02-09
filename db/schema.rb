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

ActiveRecord::Schema.define(:version => 9) do

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

  create_table "cleaners", :force => true do |t|
    t.integer  "name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "postcode_id"
    t.integer  "contact_details_id"
    t.text     "description"
    t.integer  "minimum_hire"
    t.decimal  "rate",               :precision => 4, :scale => 2
    t.decimal  "surcharge",          :precision => 4, :scale => 2
    t.integer  "availability_id"
    t.integer  "skills_id"
  end

  create_table "contact_details", :force => true do |t|
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "names", :force => true do |t|
    t.string   "honorific"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postcodes", :force => true do |t|
    t.string   "value"
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

end
