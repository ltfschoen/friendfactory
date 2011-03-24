Factory.define :site do |site|
  site.name 'Frisky Site'
  site.launch false
  site.invite_only false
end

Factory.define :invite_site, :parent => :site do |site|
  site.name 'Frisky Invite Site'
  site.invite_only true
end
