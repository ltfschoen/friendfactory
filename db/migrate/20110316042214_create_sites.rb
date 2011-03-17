class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites, :force => true do |t|
      t.string    :name, :null => false
      t.boolean   :launch
      t.string    :analytics_domain_name
      t.string    :analytics_account_number
      t.timestamps
    end
    
    add_index :sites, :name

    create_table :sites_waves, :id => false, :force => true do |t|
      t.integer :site_id
      t.integer :wave_id
    end
        
    add_index :sites_waves, [ :site_id, :wave_id ]
    add_index :sites_waves, :wave_id
    
    create_table :sites_users, :id => false, :force => true do |t|
      t.integer :site_id
      t.integer :user_id
    end
    
    add_index :sites_users, [ :site_id, :user_id ]
    add_index :sites_users, :user_id
    
    Rake::Task['ff:db:seed'].invoke

    fh = Site.find_by_name('friskyhands')
    fh.waves = Wave::Base.all
    fh.users = User.all
    
    Site.find_by_name('positivelyfrisky').users = User.where(:admin => true)    
  end

  def self.down
    drop_table :sites rescue nil
    drop_table :sites_waves rescue nil
    drop_table :sites_users rescue nil
  end
end
