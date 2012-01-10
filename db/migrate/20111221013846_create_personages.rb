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

    Personage.transaction do
      User.all.each do |user|
        persona = Persona::Base.find_by_user_id(user.id)
        profile = Wave::Profile.find_by_resource_id(persona.id)
        Personage.create!(:id => user.id, :user => user, :persona => persona, :profile => profile, :default => true)
      end
    end

    remove_column :personas, :user_id
  end

  def self.down
    add_column :personas, :user_id, :integer

    Personas::Base.transaction do
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
