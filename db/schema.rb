# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121226122459) do

  create_table "accounts", :force => true do |t|
    t.string   "state"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "type"
  end

  add_index "assets", ["name", "type"], :name => "index_assets_on_name_and_type"
  add_index "assets", ["type"], :name => "index_assets_on_type"

  create_table "biometric_people_values", :force => true do |t|
    t.integer  "person_id",  :null => false
    t.integer  "domain_id",  :null => false
    t.integer  "value_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "biometric_people_values", ["person_id", "domain_id"], :name => "index_biometric_people_values_on_person_id_and_domain_id"

  create_table "bookmarks", :force => true do |t|
    t.integer  "wave_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "read_at"
  end

  add_index "bookmarks", ["user_id"], :name => "index_bookmarks_on_user_id"
  add_index "bookmarks", ["wave_id", "user_id"], :name => "index_bookmarks_on_wave_id_and_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "friendships", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  add_index "friendships", ["type", "friend_id"], :name => "index_friendships_on_type_and_friend_id"
  add_index "friendships", ["type", "user_id", "friend_id"], :name => "index_friendships_on_type_and_user_id_and_friend_id", :unique => true

  create_table "invitation_confirmations", :force => true do |t|
    t.integer "invitation_id"
    t.integer "friendship_id"
    t.integer "invitee_id"
  end

  create_table "invitations", :force => true do |t|
    t.string   "type"
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "code"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expired_at"
  end

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

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "posting_id"
    t.datetime "created_at"
    t.datetime "read_at"
  end

  add_index "notifications", ["posting_id"], :name => "index_notifications_on_posting_id"
  add_index "notifications", ["user_id", "posting_id"], :name => "index_notifications_on_user_id_and_posting_id"

  create_table "personages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "persona_id"
    t.integer  "profile_id"
    t.string   "state"
    t.boolean  "default",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personas", :force => true do |t|
    t.date     "dob"
    t.string   "age"
    t.string   "location"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handle"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "avatar_id"
    t.string   "type"
    t.integer  "score",                                            :default => 0
    t.string   "address"
    t.string   "subpremise"
    t.string   "street_number"
    t.string   "street"
    t.string   "neighborhood"
    t.string   "sublocality"
    t.string   "locality"
    t.string   "city"
    t.string   "abbreviated_state"
    t.string   "state"
    t.string   "country"
    t.string   "post_code"
    t.decimal  "lat",               :precision => 10, :scale => 7
    t.decimal  "lng",               :precision => 10, :scale => 7
    t.boolean  "emailable",                                        :default => false
    t.boolean  "featured",                                         :default => false
  end

  add_index "personas", ["first_name"], :name => "index_user_info_on_first_name"
  add_index "personas", ["handle"], :name => "index_user_info_on_handle"

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
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "sticky_until"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "horizontal"
    t.string   "state"
    t.string   "hash_key",           :limit => 8
    t.integer  "comments_count",                  :default => 0
    t.integer  "postings_count",                  :default => 0
    t.datetime "commented_at"
    t.datetime "primed_at"
    t.integer  "feed_id"
  end

  add_index "postings", ["parent_id"], :name => "index_postings_on_parent_id"
  add_index "postings", ["resource_id", "resource_type"], :name => "index_postings_on_resource_id_and_resource_type"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "publications", :force => true do |t|
    t.integer  "wave_id",    :null => false
    t.integer  "posting_id", :null => false
    t.datetime "created_at"
    t.integer  "parent_id"
  end

  create_table "resource_embeds", :force => true do |t|
    t.integer "resource_link_id"
    t.string  "type"
    t.integer "primary",          :default => 0
    t.text    "body"
    t.integer "width"
    t.integer "height"
    t.float   "duration"
  end

  create_table "resource_events", :force => true do |t|
    t.integer  "location_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "body"
    t.string   "url"
    t.boolean  "private"
    t.boolean  "rsvp"
  end

  create_table "resource_links", :force => true do |t|
    t.integer "posting_id"
    t.text    "original_url"
    t.text    "url"
    t.string  "type"
    t.integer "cache_age"
    t.boolean "safe"
    t.string  "safe_type"
    t.text    "safe_message"
    t.string  "provider_name"
    t.string  "provider_url"
    t.string  "provider_display"
    t.text    "favicon_url"
    t.text    "title"
    t.text    "description"
    t.text    "author_name"
    t.text    "author_url"
    t.text    "content"
    t.integer "location_id"
  end

  create_table "signal_categories", :force => true do |t|
    t.string  "name",         :null => false
    t.string  "display_name"
    t.integer "site_id"
    t.integer "ordinal"
  end

  add_index "signal_categories", ["site_id"], :name => "index_signal_categories_on_site_id"

  create_table "signal_categories_signals", :force => true do |t|
    t.integer "signal_id"
    t.integer "category_id"
    t.integer "ordinal"
    t.integer "pane"
  end

  add_index "signal_categories_signals", ["category_id", "signal_id"], :name => "index_signal_categories_signals_on_category_id_and_signal_id"

  create_table "signals", :force => true do |t|
    t.string "name",         :null => false
    t.string "display_name"
    t.string "type"
  end

  add_index "signals", ["name"], :name => "index_signals_on_name", :unique => true

  create_table "sites", :force => true do |t|
    t.string   "name",                                         :null => false
    t.string   "display_name",                                 :null => false
    t.boolean  "launch",                    :default => false
    t.boolean  "invite_only",               :default => false
    t.string   "analytics_domain_name"
    t.string   "analytics_account_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "css"
    t.string   "mailer"
    t.integer  "user_id"
    t.string   "email_domain_regex"
    t.string   "email_domain_display_name"
  end

  add_index "sites", ["name"], :name => "index_sites_on_name", :unique => true

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

  create_table "stylesheets", :force => true do |t|
    t.integer  "site_id",         :null => false
    t.string   "controller_name"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stylesheets", ["site_id", "controller_name"], :name => "index_stylesheets_on_site_id_and_controller_name"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.integer  "resource_id",   :null => false
    t.string   "resource_type"
    t.string   "type",          :null => false
    t.string   "state"
    t.datetime "notified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["user_id", "resource_id", "resource_type"], :name => "index_subscriptions_on_user_id_resource_id_resource_type", :unique => true

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

  create_table "users", :force => true do |t|
    t.string   "email",                                 :null => false
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
    t.boolean  "admin",              :default => false
    t.integer  "site_id",                               :null => false
    t.integer  "account_id",                            :null => false
    t.integer  "score",              :default => 0
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["site_id", "email"], :name => "index_users_on_site_id_and_email", :unique => true

  create_table "wave_to_posting_migration_logs", :force => true do |t|
    t.integer "wave_id"
    t.integer "posting_id"
  end

  create_table "waves_not_as_postings", :force => true do |t|
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
    t.integer  "postings_count", :default => 0
  end

  add_index "waves_not_as_postings", ["resource_id", "resource_type"], :name => "index_waves_on_resource_id_and_resource_type"
  add_index "waves_not_as_postings", ["type"], :name => "index_waves_on_type"
  add_index "waves_not_as_postings", ["user_id"], :name => "index_waves_on_user_id"

end
