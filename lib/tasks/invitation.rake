namespace :ff do
  namespace :invitation do
    desc "Redeliver aging and expiring invitations for all sites"
    task :redeliver => :environment do
      Posting::Invitation.redeliver_mail
    end
  end
end