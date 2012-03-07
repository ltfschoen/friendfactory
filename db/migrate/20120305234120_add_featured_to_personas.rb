class AddFeaturedToPersonas < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false
    add_column :personas, :featured, :boolean rescue nil
    ActiveRecord::Base.transaction do
      User.includes(:personages => :persona).where('`users`.`score` > 0').all.each do |user|
        user.personages.each do |personage|
          if persona = personage.persona
            persona.update_attribute(:featured, true)
          end
        end
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
    remove_column :personas, :featured
  end
end
