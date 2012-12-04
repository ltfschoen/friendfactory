class MoveInvitationsToFriendships < ActiveRecord::Migration

  def self.up
    create_table :invitations, :force => true do |t|
      t.string    :type
      t.integer   :site_id
      t.integer   :user_id
      t.string    :email
      t.string    :code
      t.string    :state
      t.timestamps :null => true
      t.datetime  :expired_at
    end

    create_table :invitation_confirmations, :force => true do |t|
      t.integer :invitation_id
      t.integer :friendship_id
      t.integer :invitee_id
    end

    add_column :friendships, :state, :string rescue nil
    drop_table :resource_invitations rescue nil

    ActiveRecord::Base.record_timestamps = false

    ActiveRecord::Base.transaction do
      say_with_time 'moving site invitation postings to invitations' do
        # say "moved #{move_site_invitation_postings.length} site invitations"
      end
      say_with_time 'moving personal invitation postings to invitations' do
        # say "moved #{move_personal_invitation_postings.length} personal invitations"
      end
      say_with_time 'deleting invitation postings' do
        # delete_invitation_postings
      end
      say_with_time 'deleting invitation waves' do
        # delete_invitation_waves
      end
    end

    ActiveRecord::Base.record_timestamps = true
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
      code = posting_invitation.subject
      user = posting_invitation.user
      invite = Invitation::Site.new(:code => code)
      invite.state = posting_invitation.state
      invite.site_id = posting_invitation.resource_id
      invite.created_at = posting_invitation.created_at
      invite.updated_at = posting_invitation.updated_at
      user.invitations << invite
      memo << invite
    end
  end

  def self.move_personal_invitation_postings
    Posting::Invitation.where('body IS NOT NULL').all.inject([]) do |memo, posting_invitation|
      code    = posting_invitation.subject
      email   = posting_invitation.body
      user    = posting_invitation.user
      state   = posting_invitation.state
      site_id = posting_invitation.resource_id

      invite = Invitation::Personal.new(:code => code, :email => email)
      invite.created_at = posting_invitation.created_at
      invite.updated_at = posting_invitation.updated_at
      invite.site_id = site_id
      invite.state = state
      user.invitations << invite

      if invitee_user_record = User.find_by_email_and_site_id(email, site_id)
        invitee = invitee_user_record.personages.type(:person).first
        confirmation = Invitation::Confirmation.new
        confirmation.invitation = invite
        confirmation.invitee = invitee

        unless friendship = Friendship::Invitation.find_by_user_id_and_friend_id(user[:id], invitee[:id])
          friendship = Friendship::Invitation.new
          friendship.user = user
          friendship.friend = invitee
          friendship.save!
        end
        confirmation.friendship = friendship
        confirmation.save!
      end

      memo << invite
    end
  end

  def self.delete_invitation_postings
    Posting::Invitation.all.each do |posting|
      waves = posting.waves
      waves.each do |wave|
        wave.postings.delete(posting)
      end
      posting.destroy
    end
  end

  def self.delete_invitation_waves
    Wave::Invitation.all.each do |wave|
      sites = wave.sites
      sites.each { |site| site.waves.delete(wave) }
      wave.destroy
    end
  end

end
