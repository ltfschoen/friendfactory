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

ActiveRecord::Schema.define(:version => 20110608054950) do

  create_table "admin_tags", :force => true do |t|
    t.string "taggable_type", :null => false
    t.string "defective",     :null => false
    t.string "corrected"
  end

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.integer  "site_id"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "profile_id"
    t.integer  "attendance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["event_id", "profile_id"], :name => "index_invitations_on_event_id_and_profile_id"
  add_index "invitations", ["profile_id"], :name => "index_invitations_on_profile_id"

  create_table "launch_users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.string   "site"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "street"
    t.string   "locality"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "post_code"
    t.decimal  "lat",        :precision => 10, :scale => 7
    t.decimal  "lng",        :precision => 10, :scale => 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.string   "code",       :null => false
    t.integer  "site_id",    :null => false
    t.integer  "inviter_id"
    t.integer  "invitee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["code"], :name => "index_memberships_on_code"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "posting_id"
    t.datetime "created_at"
    t.datetime "read_at"
  end

  add_index "notifications", ["posting_id"], :name => "index_notifications_on_posting_id"
  add_index "notifications", ["user_id", "posting_id"], :name => "index_notifications_on_user_id_and_posting_id"

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
    t.boolean  "active"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "horizontal"
    t.string   "state"
  end

  add_index "postings", ["parent_id"], :name => "index_postings_on_parent_id"
  add_index "postings", ["resource_id", "resource_type"], :name => "index_postings_on_resource_id_and_resource_type"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "postings_deleted", :id => false, :force => true do |t|
    t.integer  "id",                 :default => 0, :null => false
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
    t.boolean  "active"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "horizontal"
  end

  create_table "postings_waves", :id => false, :force => true do |t|
    t.integer "posting_id"
    t.integer "wave_id"
  end

  add_index "postings_waves", ["posting_id", "wave_id"], :name => "index_postings_waves_on_posting_id_and_wave_id"
  add_index "postings_waves", ["wave_id"], :name => "index_postings_waves_on_wave_id"

  create_table "postings_waves_sans_id", :id => false, :force => true do |t|
    t.integer "posting_id"
    t.integer "wave_id"
  end

  add_index "postings_waves_sans_id", ["posting_id", "wave_id"], :name => "index_postings_waves_on_posting_id_and_wave_id"
  add_index "postings_waves_sans_id", ["wave_id"], :name => "index_postings_waves_on_wave_id"

  create_table "publications", :force => true do |t|
    t.integer  "wave_id",       :null => false
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["resource_id"], :name => "index_publications_on_resource_id"
  add_index "publications", ["wave_id", "resource_id"], :name => "index_publications_on_wave_id_and_resource_id"

  create_table "resource_events", :force => true do |t|
    t.integer  "location_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "body"
    t.string   "url"
    t.boolean  "private"
    t.boolean  "rsvp"
  end

  create_table "resource_events_bak", :id => false, :force => true do |t|
    t.integer  "id",         :default => 0, :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "private"
    t.boolean  "rsvp"
  end

  create_table "resource_invitations", :force => true do |t|
    t.datetime "expires_at"
  end

  create_table "signal_categories", :force => true do |t|
    t.string  "name",         :null => false
    t.string  "display_name"
    t.integer "site_id"
    t.string  "subject_type"
    t.integer "ordinal"
  end

  add_index "signal_categories", ["site_id"], :name => "index_signal_categories_on_site_id"

  create_table "signal_categories_signals", :force => true do |t|
    t.integer "site_id"
    t.integer "signal_id"
    t.integer "category_id"
    t.integer "ordinal"
  end

  create_table "signals", :force => true do |t|
    t.string "name",         :null => false
    t.string "display_name"
    t.string "type"
  end

  add_index "signals", ["name"], :name => "index_signals_on_name", :unique => true

  create_table "sites", :force => true do |t|
    t.string   "name",                                        :null => false
    t.string   "display_name",                                :null => false
    t.boolean  "launch",                   :default => false
    t.boolean  "invite_only",              :default => false
    t.string   "analytics_domain_name"
    t.string   "analytics_account_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "css"
  end

  add_index "sites", ["name"], :name => "index_sites_on_name", :unique => true

  create_table "sites_signals", :force => true do |t|
    t.integer "site_id"
    t.integer "signal_id"
    t.integer "category_id"
    t.integer "ordinal"
  end

  add_index "sites_signals", ["category_id"], :name => "index_sites_signals_on_category_id"
  add_index "sites_signals", ["signal_id"], :name => "index_sites_signals_on_signal_id"
  add_index "sites_signals", ["site_id", "signal_id"], :name => "index_sites_signals_on_site_id_and_signal_id"

  create_table "sites_users", :id => false, :force => true do |t|
    t.integer "site_id"
    t.integer "user_id"
  end

  add_index "sites_users", ["site_id", "user_id"], :name => "index_sites_users_on_site_id_and_user_id"
  add_index "sites_users", ["user_id"], :name => "index_sites_users_on_user_id"

  create_table "sites_waves", :id => false, :force => true do |t|
    t.integer "site_id"
    t.integer "wave_id"
  end

  add_index "sites_waves", ["site_id", "wave_id"], :name => "index_sites_waves_on_site_id_and_wave_id"
  add_index "sites_waves", ["wave_id"], :name => "index_sites_waves_on_wave_id"

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

  create_table "uber_waves", :id => false, :force => true do |t|
    t.integer "uber_wave_id"
    t.integer "wave_id"
  end

  add_index "uber_waves", ["uber_wave_id", "wave_id"], :name => "index_uber_waves_on_uber_wave_id_and_wave_id"
  add_index "uber_waves", ["wave_id"], :name => "index_uber_waves_on_wave_id"

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
    t.string   "handle"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "user_info", ["first_name"], :name => "index_user_info_on_first_name"
  add_index "user_info", ["handle"], :name => "index_user_info_on_handle"

  create_table "user_info_deleted", :id => false, :force => true do |t|
    t.integer  "id",           :default => 0, :null => false
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
    t.string   "email",                                 :null => false
    t.string   "handle"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "slug"
    t.date     "dob"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "emailable",          :default => true
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["handle"], :name => "index_users_on_handle"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "users_deleted", :id => false, :force => true do |t|
    t.integer  "id",                 :default => 0, :null => false
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
    t.string   "state"
  end

  add_index "waves", ["resource_id", "resource_type"], :name => "index_waves_on_resource_id_and_resource_type"

  create_table "waves_deleted", :id => false, :force => true do |t|
    t.integer  "id",            :default => 0, :null => false
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

end
