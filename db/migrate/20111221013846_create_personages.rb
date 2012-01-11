class CreatePersonages < ActiveRecord::Migration
  def self.up
    create_table :personages, :force => true do |t|
      t.integer :user_id
      t.integer :persona_id
      t.integer :profile_id
      t.boolean :default, :default => false
      t.timestamps
    end

    Personage.class_eval {
      attr_accessible :id, :user, :persona, :profile, :default
    }

    say_with_time 'initializing user personages' do
      ActiveRecord::Base.transaction do
        User.all.each do |user|
          persona = Persona::Base.find_by_user_id(user.id)
          profile = Wave::Profile.find_by_user_id(user.id)
          Personage.create!(:id => user.id, :user => user, :persona => persona, :profile => profile, :default => true)
        end
      end
    end

    say_with_time 'initializing community personages' do
      ActiveRecord::Base.transaction do
        Wave::Community.all.each do |wave|
          wave.sites.each do |site|
            if user = site.users.find_by_email('michael@michaelbamford.com')
              personage = Personage.create!(
                  :default => true,
                  :user    => user,
                  :profile => wave,
                  :persona_attributes => { :type => 'Persona::Community', :handle => 'Community' })
              wave[:user_id] = personage.id
              wave.save!
            end
          end
        end
      end
    end

    remove_column :personas, :user_id
  end

  def self.down
    add_column :personas, :user_id, :integer

    ActiveRecord::Base.transaction do
      Personage.all.each do |personage|
        if persona = personage.persona
          persona.user_id = personage.user_id
          persona.save!
        end
      end
    end

    drop_table :personages rescue nil
  end
end
