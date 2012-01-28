class MoveInvitationsToFriendships < ActiveRecord::Migration

  def self.up
    create_table :invitations, :force => true do |t|
      t.string    :type
      t.integer   :user_id
      t.string    :email
      t.string    :code
      t.string    :state
      t.timestamps
      t.datetime  :expires_at
    end
    
    create_table :invitation_confirmations, :force => true do |t|
      t.integer :invitation_id
      t.integer :friendship_id
      t.integer :invitee_id
    end

    add_column :friendships, :state, :string
    drop_table :resource_invitations

    ActiveRecord::Base.transaction do
      say_with_time 'moving invitation postings to invitations' do
        # move_anonymous_invitation_postings_to_friendships
        # move_personal_invitation_postings_to_friendships
      end
    end
  end

  def self.down
    create_table :resource_invitations, :force => true do |t|
      t.datetime :expires_at
    end

    remove_column :friendships, :state
    drop_table :invitation_confirmations
    drop_table :invitations
  end

  def self.move_anonymous_invitation_postings_to_friendships
    Posting::Invitation.where(:body => nil).all.each do |invitation|
      site = invitation.site
      code = invitation.code
      home_user = site.home_user
      
      home_user.friends.create({:type => 'invitation', :invitation_resource_attributes => { :code => code }})
    end
  end
  
  def self.personal_invitation_postings_to_friendships
  end

end
