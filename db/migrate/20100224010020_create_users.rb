class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string    :email, :null => false
      t.string    :handle
      t.string    :first_name
      t.string    :last_name
      t.string    :slug
      t.date      :dob
      t.string    :status
      t.timestamps :null => true

      # Authlogic columns
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :persistence_token
      t.string    :perishable_token
      t.integer   :login_count,        :null => false, :default => 0
      t.integer   :failed_login_count, :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
    end
    add_index :users, :handle
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :persistence_token
    add_index :users, :last_request_at
  end

  def self.down
    drop_table :users rescue nil
  end
end
