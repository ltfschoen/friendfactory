class CreatePersonas < ActiveRecord::Migration

  def self.up
    rename_table   :user_info, :personas
    add_column     :personas, :avatar_id, :integer
    add_column     :personas, :type, :string
    rename_column  :personas, :about_me, :description 
    remove_columns :personas, :gender, :orientation, :relationship, :deafness

    say_with_time 'initializing all personas to Persona::Person' do
      Persona::Base.update_all(:type => 'Persona::Person')
    end

    say_with_time 'initializing avatar_id' do
      Persona::Person.transaction do
        Persona::Person.includes(:profile).all.each do |person|
          if avatar = person.profile.postings.
              where(:type => Posting::Avatar, :parent_id => nil, :active => true, :state => :published).
              order('`postings`.`created_at` DESC').
              limit(1).first
            person.avatar_id = avatar.id
            person.save(false)
          end
        end
      end
    end

    remove_column :postings, :active
  end

  def self.down
    add_column :postings, :active, :boolean

    say_with_time 'initializing active avatars' do
      Persona::Person.transaction do
        Persona::Person.all.each do |person|
          avatar = person.avatar
          if avatar && !avatar.silhouette?
            avatar.active = true
            avatar.save(false)
          end
        end
      end
    end

    rename_table  :personas,  :user_info
    remove_column :user_info, :avatar_id
    remove_column :user_info, :type
    rename_column :user_info, :description, :about_me
    add_column    :user_info, :gender, :integer
    add_column    :user_info, :orientation, :integer
    add_column    :user_info, :relationship, :integer
    add_column    :user_info, :deafness, :integer
  end

end
