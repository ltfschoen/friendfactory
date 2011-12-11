class CreateBiometricPeopleValues < ActiveRecord::Migration
  def self.up
    create_table :biometric_people_values, :force => true do |t|
      t.integer :person_id, :null => false
      t.integer :domain_id, :null => false
      t.integer :value_id
      t.string  :value
    end
    add_index :biometric_people_values, [ :person_id, :domain_id ]
  end

  def self.down
    drop_table :biometric_people_values rescue nil
  end
end
