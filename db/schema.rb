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

ActiveRecord::Schema.define(:version => 20100427024309) do

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "buddy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postings", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "wave_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
    t.boolean  "private"
    t.integer  "receiver_id"
    t.text     "subject"
    t.datetime "read_at"
    t.datetime "sender_deleted_at"
    t.datetime "receiver_deleted_at"
    t.boolean  "active"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "postings", ["parent_id"], :name => "index_postings_on_parent_id"
  add_index "postings", ["receiver_id"], :name => "index_postings_on_receiver_id"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "postings_profiles", :id => false, :force => true do |t|
    t.integer "posting_id"
    t.integer "profile_id"
  end

  add_index "postings_profiles", ["posting_id", "profile_id"], :name => "index_postings_profiles_on_posting_id_and_profile_id"
  add_index "postings_profiles", ["profile_id"], :name => "index_postings_profiles_on_profile_id"

  create_table "user_info", :force => true do |t|
    t.integer  "user_id"
    t.date     "dob"
    t.integer  "gender"
    t.integer  "orientation"
    t.integer  "relationship"
    t.string   "location"
    t.integer  "deafness"
    t.text     "about_me"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                             :null => false
    t.string   "handle"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "dob"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["handle"], :name => "index_users_on_handle"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "waves", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "topic"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
