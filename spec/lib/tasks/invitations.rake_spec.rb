require 'spec_helper'
require 'rake'

describe "Invitation rake tasks" do
  let(:rake) { @rake }

  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    load File.join(Rails.root, 'lib/tasks/invitations.rake')
    Rake::Task.define_task(:environment)
  end

  after(:each) do
    Rake.application = nil
  end

  describe "ff:invitations:redeliver" do
    let(:task_name) { "ff:invitations:redeliver" }
    let(:today) { DateTime.civil(2011, 1, 15, 1) }
    let(:invitations) { @invitations }

    before(:each) do
      Date.stub!(:today).and_return(today)
      Posting::Invitation.stub!(:FIRST_REMINDER_AGE).and_return(1.day)
      Posting::Invitation.stub!(:SECOND_REMINDER_AGE).and_return(7.days)
      Posting::Invitation.stub!(:EXPIRATION_AGE).and_return(10.days)

      @invitations = 0.upto(12).inject({}) do |memo, age|
        created_at = today - age.days
        invitation = Posting::Invitation.create!(
          :site => mock_model(Site),
          :sponsor => mock_model(Personage),
          :body => "invite-#{age}",
          :state => 'offered',
          :created_at => created_at)
        memo[created_at.strftime('%Y%m%d').to_sym] = invitation
        memo
      end
    end

    it "should have 'environment' as a prereq" do
      pending
      rake[task_name].prerequisites.should include("environment")
    end

    it "redelivers email with the InvitationsMailer" do
      pending
      mail_message = mock(Mail::Message).as_null_object
      InvitationsMailer.should_receive(:new_invitation_mail).with(invitations[:'20110104']).ordered.and_return(mail_message)
      InvitationsMailer.should_receive(:new_invitation_mail).with(invitations[:'20110107']).ordered.and_return(mail_message)
      InvitationsMailer.should_receive(:new_invitation_mail).with(invitations[:'20110113']).ordered.and_return(mail_message)
      rake[task_name].invoke
    end
  end

end
