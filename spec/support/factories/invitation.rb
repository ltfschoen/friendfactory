Factory.define :invitation do |invitation|
  invitation.code 666
  invitation.association :site, :factory => :invite_site
  invitation.association :sponsor, :factory => :charlie
end
