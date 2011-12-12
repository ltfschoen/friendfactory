class CreateAccounts < ActiveRecord::Migration
  
  class XUser < ActiveRecord::Base
    set_table_name :users
    has_many :waves, :class_name => 'Wave::Base', :foreign_key => 'user_id'
    has_and_belongs_to_many :sites, :uniq => true, :join_table => 'sites_users', :foreign_key => 'user_id'
    has_many :bookmarks, :foreign_key => 'user_id'
  end

  class NUser < ActiveRecord::Base
    set_table_name :users
  end

  def self.up
    create_table :accounts, :force => true do |t|
      t.string :state
      t.integer :parent_id
      t.timestamps
    end

    add_column :users, :site_id, :integer
    add_column :users, :account_id, :integer

    remove_index :users, :column => :email
    add_index :users, [ :site_id, :email ], :unique => true
    add_index :users, :email

    XUser.reset_column_information
    NUser.reset_column_information

    say_with_time 'migrating users from multi-site to uni-site model' do
      ActiveRecord::Base.record_timestamps = false
      Account.transaction do
        XUser.all.each do |xuser|
          create_user_for_each_site(xuser, create_account(xuser))
        end
      end
    end

    say_with_time 'fixing Person#user_id and handle' do
      Person.transaction do
        Wave::Profile.all.each do |profile|
          person = profile.user_info
          if person[:user_id].nil?
            person.update_attribute(:user_id, profile[:user_id])
          end
          if person[:handle].nil?
            person.update_attribute(:handle, person[:first_name])
          end
        end
      end
    end

    change_column :users, :site_id, :integer, :null => false
    change_column :users, :account_id, :integer, :null => false
    add_index :users, :account_id

    # TODO: drop_table :sites_users
  end

  def self.down
    drop_table :accounts
    remove_column :users, :account_id
    remove_column :users, :site_id
    add_index :users, :email, :uniq => true
  end

  private

  def self.create_account(xuser)
    time_now = Time.now
    account = Account.create!(:created_at => time_now, :updated_at => time_now)
    xuser.update_attribute(:account_id, account.id)
    account
  end

  def self.create_user_for_each_site(xuser, account)
    sites = xuser.sites
    if site = sites.shift
      xuser.update_attribute(:site_id, site.id)
    end

    if sites.length > 0
      xuser_attributes = xuser.attributes.except('id', 'site_id', 'account_id')
      sites.each do |site|
        nuser_attributes = xuser_attributes.merge({ :site_id => site.id, :account_id => account.id })
        nuser = NUser.create!(nuser_attributes)
        update_waves(xuser, nuser, site)
        update_postings(xuser, nuser, site)
        update_bookmarks(xuser, nuser, site)
      end
    end
  end

  def self.update_waves(xuser, nuser, site)
    # If wave is on more than one site, we'd should duplicate the
    # wave and give the new wave the new user_id. At the time of writing,
    # all waves exist only on one site, so no need to worry about this.
    xuser.waves.site(site).update_all(:user_id => nuser.id)
  end

  def self.update_postings(xuser, nuser, site)
    # Assign a single user_id to a posting, regardless if it is
    # on multiple waves which themselves are on different sites.
    # At the time of writing, all postings exist in waves that
    # are all on the one site, so no need to worry about this.
    postings = Posting::Base.where(:user_id => xuser.id).includes(:waves).select do |posting|
      posting.waves.map(&:sites).flatten.map(&:id).uniq.detect { |site_id| site_id == site.id }
    end
    Posting::Base.update_all([ 'user_id = ?', nuser.id ], :id => postings.map(&:id))
  end

  def self.update_bookmarks(xuser, nuser, site)
    xuser.bookmarks.where(:wave_id => site.wave_ids).update_all(:user_id => nuser.id)
  end

end
