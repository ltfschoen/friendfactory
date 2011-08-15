namespace :ff do
  namespace :invitations do
    desc "Redeliver aging and expiring invitations for all sites"
    task :redeliver => :environment do
      invitations = Posting::Invitation.offered.not_redundant.expiring + Posting::Invitation.offered.not_redundant.aging
      invitations.each do |invitation|
        InvitationsMailer.new_invitation_mail(invitation).deliver
      end
    end
  end
end