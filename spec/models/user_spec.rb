require 'spec_helper'

describe User do

  include Authlogic::TestCase

  let(:attrs) do
    { :email => 'zed@test.com',
      :person_attributes => {
        :handle => 'zed',
        :age => '42',
        :location => 'Sydney' },
      :password => 'test',
      :password_confirmation => 'test' }
  end

  before(:each) do
    activate_authlogic
    UserSession.stub!(:find).and_return(mock(UserSession, :record => mock_model(User)))
  end

  describe 'attributes' do
    describe 'at open site' do
      let(:current_site) { mock_model(Site, :invite_only? => false) }

      it 'is valid with valid attributes' do
        User.new(attrs) { |user| user.site = current_site }.should be_valid
      end

      it 'requires a site' do
        pending
        user = User.new(attrs)
        user.valid?
        user.errors.on(:site).should_not be_empty
      end

      it 'requires an email' do
        pending
        user = User.new(attrs.except(:email))
        user.valid?
        user.errors.on(:'email').should_not be_empty
      end

      it 'requires a handle' do
        pending
        person_attributes = attrs.delete(:person_attributes).except(:handle)
        user = User.new(attrs.merge({ :person_attributes => person_attributes }))
        user.valid?
        user.errors.on(:'person.handle').should_not be_empty
      end

      it 'requires an age' do
        pending
        person_attributes = attrs.delete(:person_attributes).except(:age)
        user = User.new(attrs.merge({ :person_attributes => person_attributes }))
        user.valid?
        user.errors.on(:'person.age').should_not be_empty
      end

      it 'requires a location' do
        pending
        person_attributes = attrs.delete(:person_attributes).except(:location)
        user = User.new(attrs.merge({ :person_attributes => person_attributes }))
        user.valid?
        user.errors.on(:'person.location').should_not be_empty
      end
    end

    describe 'invite-only site' do
      let(:current_site) do
        site = mock_model(Site, :invite_only? => true)
        site.stub_chain(:invitations, :offered, :find_by_code).and_return('666')
        site.stub_chain(:invitations, :offered, :personal, :find_by_code)
        site
      end

      it 'is valid with valid attributes' do
        user = User.new(attrs.merge(:invitation_code => "666")) { |user| user.site = current_site }
        user.should be_valid
      end

      it 'requires an invitation code' do
        pending
        user = User.new { |user| user.site = current_site }
        user.valid?
        user.errors.on(:invitation_code).should_not be_empty
      end
    end

    it 'requires something that looks like an email' do
      user = User.new(attrs)
      user.email = 'crap'
      user.should_not be_valid
    end

    it 'emailable by default' do
      pending
      User.new(attrs).should be_emailable
    end

    it 'is not emailable' do
      pending
      user = User.new(attrs)
      user.emailable = false
      user.should_not be_emailable
    end

    it 'is not an admin by default' do
      pending
      User.new(attrs).should_not be_an_admin
    end

    it 'requires password confirmation to match password' do
      pending
      user = User.new(attrs)
      user.password_confirmation = 'crap'
      user.valid?
      user.errors.on(:password).should_not be_empty
    end
  end

  describe 'state' do
    fixtures :sites, :users

    it 'disabled is not emailable' do
      pending
      user = users(:adam)
      user.disable!
      user.should_not be_emailable
    end
  end

  describe 'enrollment' do
    fixtures :sites, :users
    set_fixture_class :waves => 'Wave::Base'

    let(:invitation_only_site) { :positivelyfrisky }

    def new_user(site, additional_attrs = {})
      User.new(attrs.merge(additional_attrs)) { |user| user.site = sites(site) }
    end

    def new_invitation(options = {})
      # TODO Expecting a personage(:adam), not a users(:adam)
      attrs = { :sponsor => users(:adam), :site => sites(invitation_only_site), :code => '666' }
      Posting::Invitation.create!(attrs.merge(options))
    end

    it 'is valid in different sites with same email address' do
      pending
      user = new_user(:friskyhands)
      user.save!
      user = new_user(:positivelyfrisky, :invitation_code => 'e5')
      user.should be_valid
    end

    describe "already enrolled" do
      it "is invalid at an open site" do
        pending
        new_user(:friskyhands).save!
        user = new_user(:friskyhands)
        user.valid?
        user.errors.on(:email).should_not be_empty
      end

      it "is invalid at an invite-only site with a valid invitation code" do
        pending
        new_user(:positivelyfrisky, :invitation_code => 'e5').save!
        user = new_user(:positivelyfrisky, :invitation_code => 'e5')
        user.valid?
        user.errors.on(:email).should_not be_empty
      end
    end

    describe "invite-only sites" do
      describe "with a personal invitation" do
        it "is valid for valid invitation code" do
          pending
          user = new_user(invitation_only_site, :invitation_code => 'e5')
          user.should be_valid
        end

        it "is invalid without an invitation code" do
          pending
          user = new_user(invitation_only_site)
          user.valid?
          user.errors.on(:invitation_code).should_not be_empty
        end

        it "is invalid with an invalid invitation code" do
          pending
          user = new_user(invitation_only_site, :invitation_code => '666')
          user.valid?
          user.errors.on(:invitation_code).should_not be_empty
        end

        it "is valid if invitation in offered state" do
          pending
          user = new_user(invitation_only_site, :invitation_code => '666')
          new_invitation(:email => user.email).offer!
          user.should be_valid
        end

        it "is invalid if invitation exists but not in offered state" do
          pending
          user = new_user(invitation_only_site, :invitation_code => '666')
          invitation = new_invitation(:email => user.email)
          invitation.offer!
          invitation.accept!
          user.valid?
          user.errors.on(:invitation_code).should_not be_empty
        end

        it "should be in accepted state after accepted" do
          pending
          user = new_user(invitation_only_site, :invitation_code => '666')
          invitation = new_invitation(:email => user.email)
          invitation.offer!
          user.save!
          invitation.reload.state.should == 'accepted'
        end

        it "sets user's email from the invitation if it's empty" do
          pending
          new_invitation({ :email => 'blah@blah.com' }).offer!
          user = User.new(attrs.merge({ :invitation_code => '666' }).except(:email)) { |user| user.site = sites(invitation_only_site) }
          user.email.should == 'blah@blah.com'
        end

        it "doesn't set user's email from the invitation if email already exists" do
          pending
          new_invitation({ :email => 'blah@blah.com' }).offer!
          user = new_user(invitation_only_site, :invitation_code => '666')
          user.email.should == attrs[:email]
        end
      end

      describe "with an anonymous invitation" do
        it "is valid for an existing user" do
          pending
          new_invitation.offer!
          new_user(:friskyhands).save!
          new_user(invitation_only_site, :invitation_code => '666').should be_valid
        end

        it "is valid for a new user" do
          pending
          new_invitation.offer!
          new_user(invitation_only_site, :invitation_code => '666').should be_valid
        end

        it "is valid if invitation in offered state" do
          pending
          new_iPersoangenvitation.offer!
          new_user(invitation_only_site, :invitation_code => '666').should be_valid
        end

        it "is invalid if invitation in accepted state" do
          pending
          new_invitation(:state => 'accepted')
          user = new_user(invitation_only_site, :invitation_code => '666')
          user.valid?
          user.errors.on(:invitation_code).should_not be_empty
        end

        it "is invalid if invitation in expired state" do
          pending
          new_invitation(:state => 'expired')
          user = new_user(invitation_only_site, :invitation_code => '666')
          user.valid?
          user.errors.on(:invitation_code).should_not be_empty
        end

        it "should remain in offered state after being accepted" do
          pending
          invitation = new_invitation
          invitation.offer!
          new_user(invitation_only_site, :invitation_code => '666').should be_valid
          invitation.reload.state.should == 'offered'
        end

        it "doesn't set the user's email from the invitation when first initializing" do
          pending
          new_invitation(:email => 'blah@blah.com').offer!
          user = User.new(attrs.merge(:invitation_code => '666').except(:email))
          user.email.should be_blank
        end
      end

      describe "without an invitation" do
        it "is invalid for an existing user" do
          pending
          new_invitation.offer!
          new_user(:friskyhands).save!
          new_user(invitation_only_site).should_not be_valid
        end

        it "is invalid for a new user" do
          new_user(invitation_only_site).should_not be_valid
        end
      end
    end

    describe "open sites" do
      describe "without an invitation" do
        let(:invitation_only_site) { :positivelyfrisky }

        it "is valid for an existing user" do
          pending
          new_invitation.offer!
          new_user(invitation_only_site, :invitation_code => '666').save!
          new_user(:friskyhands).should be_valid
        end

        it "is valid for a new user" do
          new_user(:friskyhands).should be_valid
        end

        it "ignores invitation code if provided" do
          new_user(:friskyhands, :invitation_code => '666').should be_valid
        end
      end
    end
  end

end
