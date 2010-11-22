# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101122105517) do

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posting_chats", :force => true do |t|
    t.integer "receiver_id"
    t.text    "body"
  end

  add_index "posting_chats", ["receiver_id"], :name => "index_posting_chats_on_receiver_id"

  create_table "postings", :force => true do |t|
    t.string   "type"
    t.string   "slug"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "subject"
    t.text     "body"
    t.boolean  "private",             :default => false
    t.integer  "receiver_id"
    t.datetime "read_at"
    t.datetime "sender_deleted_at"
    t.datetime "receiver_deleted_at"
    t.boolean  "active"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "horizontal"
  end

  add_index "postings", ["parent_id"], :name => "index_postings_on_parent_id"
  add_index "postings", ["receiver_id"], :name => "index_postings_on_receiver_id"
  add_index "postings", ["resource_id", "resource_type"], :name => "index_postings_on_resource_id_and_resource_type"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "postings_waves", :id => false, :force => true do |t|
    t.integer "posting_id"
    t.integer "wave_id"
  end

  add_index "postings_waves", ["posting_id", "wave_id"], :name => "index_postings_waves_on_posting_id_and_wave_id"
  add_index "postings_waves", ["wave_id"], :name => "index_postings_waves_on_wave_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_info", :force => true do |t|
    t.integer  "user_id"
    t.date     "dob"
    t.string   "age"
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
    t.string   "slug"
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

  create_table "users_prelaunch", :id => false, :force => true do |t|
    t.integer  "id",                 :default => 0, :null => false
    t.string   "email",                             :null => false
    t.string   "handle"
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
    t.string   "domain"
  end

  create_table "waves", :force => true do |t|
    t.string   "type"
    t.string   "slug"
    t.integer  "user_id"
    t.string   "topic"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resource_id"
    t.string   "resource_type"
  end

  add_index "waves", ["resource_id", "resource_type"], :name => "index_waves_on_resource_id_and_resource_type"

end
