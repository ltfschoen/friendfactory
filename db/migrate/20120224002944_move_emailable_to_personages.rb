class MoveEmailableToPersonages < ActiveRecord::Migration
  def self.up
    User.transaction do
      ActiveRecord::Base.record_timestamps = false
      add_column :personages, :emailable, :boolean rescue nil
      User.includes(:personages).all.each do |user|
        user.personages.each do |personage|
          personage.update_attribute(:emailable, user[:emailable])
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
      User.includes(:default_personage).all.each do |user|
        if default_personage = user.default_personage
          user.update_attribute(:emailable, default_personage[:emailable])
        end
      end
      remove_column :personages, :emailable
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
