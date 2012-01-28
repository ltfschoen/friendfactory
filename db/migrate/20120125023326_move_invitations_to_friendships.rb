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
        move_site_invitation_postings
        move_personal_invitation_postings
        delete_posting_invitations
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

  private

  def self.move_site_invitation_postings
    Posting::Invitation.where(:body => nil).all.inject([]) do |memo, posting_invitation|
      code   = posting_invitation.subject
      user   = posting_invitation.user
      state  = posting_invitation.state
      invite = Invitation::Site.new(:code => code)
      invite.state = state
      user.invitations << invite
      memo << invite
    end
  end

  def self.move_personal_invitation_postings
    Posting::Invitation.where('`body` IS NOT NULL').all.inject([]) do |memo, posting_invitation|
      code    = posting_invitation.subject
      email   = posting_invitation.body
      user    = posting_invitation.user
      state   = posting_invitation.state
      invite  = Invitation::Personal.new(:code => code, :email => email)
      invite.state = state
      user.invitations << invite
      memo << invite

      site = posting_invitation.site
      if invitee_user_record = User.find_by_email_and_site_id(email, site[:id])
        invitee = invitee_user_record.personages.type(Persona::Person).first
        confirmation = Invitation::Confirmation.new
        confirmation.invitation = invite
        confirmation.invitee = invitee
        confirmation.save!

        unless Friendship::Invitation.exists?(:user_id => user[:id], :friend_id => invitee[:id])
          friendship = Friendship::Invitation.new
          friendship.user = user
          friendship.friend = invitee
          friendship.save!
        end
      end
      memo
    end
  end

  def self.delete_posting_invitations
    Posting::Invitation.all.each do |posting|
      waves = posting.waves
      wave.each do |wave|
        wave.postings.delete(posting)
      end
      posting.destroy
    end
  end

end
