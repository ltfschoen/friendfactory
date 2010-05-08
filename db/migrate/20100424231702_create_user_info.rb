class CreateUserInfo < ActiveRecord::Migration
  def self.up
    create_table :user_info do |t|
      t.integer   :user_id
      t.date      :dob
      t.string    :age
      t.integer   :gender
      t.integer   :orientation
      t.integer   :relationship
      t.string    :location
      t.integer   :deafness
      t.text      :about_me
      t.timestamps
    end
  end

  def self.down
    drop_table :user_info rescue nil
  end
end
