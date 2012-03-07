class MoveEmailableToPersonas < ActiveRecord::Migration
  def self.up
    User.transaction do
      ActiveRecord::Base.record_timestamps = false
      add_column :personas, :emailable, :boolean
      User.includes(:personages => :persona).all.each do |user|
        user.personages.each do |personage|
          if persona = personage.persona
            persona.update_attribute(:emailable, user[:emailable])
          end
        end
      end
      remove_column :users, :emailable
      ActiveRecord::Base.record_timestamps = true
    end
  end

  def self.down
    User.transaction do
      ActiveRecord::Base.record_timestamps = false
      add_column :users, :emailable, :boolean
      User.includes(:default_personage => :persona).all.each do |user|
        default_personage = user.default_personage
        if default_personage && persona = default_personage.persona
          user.update_attribute(:emailable, persona[:emailable])
        end
      end
      remove_column :personas, :emailable
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
