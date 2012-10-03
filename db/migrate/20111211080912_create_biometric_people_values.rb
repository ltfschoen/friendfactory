class CreateBiometricPeopleValues < ActiveRecord::Migration
  def self.up
    create_table :biometric_people_values, :force => true do |t|
      t.integer :person_id, :null => false
      t.integer :domain_id, :null => false
      t.integer :value_id
      t.string  :value
      t.timestamps
    end

    say_with_time "Migrating user_info attributes to biometric_people_values" do
      # ActiveRecord::Base.transaction do
      #   Person.includes(:user => :site).all.each do |person|
      #     site = person.user.site
      #     site.biometric_domains.each do |domain|
      #       value_id_attr = :"#{domain.name}_id"
      #       if person.respond_to?(value_id_attr) && value_id = person.send(value_id_attr)
      #         person.biometric_person_values.create(:domain_id => domain.id, :value_id => value_id)
      #       end
      #     end
      #   end
      # end
    end

    add_index :biometric_people_values, [ :person_id, :domain_id ]
  end

  def self.down
    drop_table :biometric_people_values rescue nil
  end
end
