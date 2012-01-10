class CreateRoles < ActiveRecord::Migration
  def self.up
    return

    create_table :roles, :force => true do |t|
      t.string :name, :null => false
      t.string :display_name, :null => false
      t.string :default_profile_type, :null => false
      t.string :default_persona_type, :null => false
    end

    Role.reset_column_information

    Role.transaction do
      create_role 'user', 'User', 'Wave::Profile', 'Persona::Person'
      create_role 'administrator', 'Administrator', 'Wave::Profile', 'Persona::Person'
      create_role 'ambassador', 'Ambassador', 'Wave::Ambassador', 'Persona::Ambassador'
      create_role 'community', 'Community', 'Wave::Community', 'Persona::Community'
      create_role 'place', 'Place', 'Wave::Place', 'Persona::Place'    
    end
  end

  def self.down
    return

    drop_table :roles rescue nil
  end

  private

  def self.create_role(name, display_name, default_profile_type, default_persona_type)
    Role.find_or_create_by_name(
      :name => name,
      :display_name => display_name,
      :default_profile_type => default_profile_type,
      :default_persona_type => default_persona_type)
  end
end
