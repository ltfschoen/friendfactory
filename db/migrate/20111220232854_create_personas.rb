class CreatePersonas < ActiveRecord::Migration

  def self.up
    rename_table   :user_info, :personas

    add_column     :personas, :avatar_id,         :integer
    add_column     :personas, :type,              :string
    add_column     :personas, :score,             :integer, :default => 0
    add_column     :personas, :address,           :string
    add_column     :personas, :subpremise,        :string
    add_column     :personas, :street_number,     :string
    add_column     :personas, :street,            :string
    add_column     :personas, :neighborhood,      :string
    add_column     :personas, :sublocality,       :string
    add_column     :personas, :locality,          :string
    add_column     :personas, :city,              :string
    add_column     :personas, :abbreviated_state, :string
    add_column     :personas, :state,             :string
    add_column     :personas, :country,           :string
    add_column     :personas, :post_code,         :string
    add_column     :personas, :lat,               :decimal, :precision => 10, :scale => 7
    add_column     :personas, :lng,               :decimal, :precision => 10, :scale => 7

    rename_column  :personas, :about_me, :description
    remove_columns :personas, :gender, :orientation, :relationship, :deafness

    Persona::Base.reset_column_information

    say_with_time 'initializing all personas to Persona::Person' do
      Persona::Base.update_all(:type => 'Persona::Person')
    end

    say_with_time 'initializing avatar_id' do
      ActiveRecord::Base.transaction do
        Persona::Person.all.each do |person|
          if profile = Wave::Profile.find_by_resource_id(person.id)
            if avatar = profile.postings.
                where(:type => Posting::Avatar, :parent_id => nil, :active => true, :state => :published).
                order('`postings`.`created_at` DESC').
                limit(1).first
              person.avatar_id = avatar.id
              person.save!(:validate => false)
            end
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
            avatar.save!(:validate => false)
          end
        end
      end
    end

    rename_table  :personas,  :user_info

    remove_column :user_info, :avatar_id
    remove_column :user_info, :type
    remove_column :user_info, :score
    rename_column :user_info, :description, :about_me
    remove_column :user_info, :address
    remove_column :user_info, :subpremise
    remove_column :user_info, :street_number
    remove_column :user_info, :street
    remove_column :user_info, :neighborhood
    remove_column :user_info, :sublocality
    remove_column :user_info, :locality
    remove_column :user_info, :city
    remove_column :user_info, :state
    remove_column :user_info, :country
    remove_column :user_info, :post_code
    remove_column :user_info, :lat
    remove_column :user_info, :lng

    rename_column :user_info, :description, :about_me
    add_column    :user_info, :gender, :integer
    add_column    :user_info, :orientation, :integer
    add_column    :user_info, :relationship, :integer
    add_column    :user_info, :deafness, :integer
  end

end
