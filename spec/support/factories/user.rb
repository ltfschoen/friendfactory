Factory.define :adam, :class => User do |user|
  user.handle 'adam'
  user.email 'adam@test.com'
  user.password 'test'
  user.password_confirmation 'test'
  user.current_site Factory.build(:site)
  # user.invitations { |invitations| [ invitations.association(:invitation) ]}
end

Factory.define :bert, :class => User do |user|
  user.handle 'bert'
  user.email 'bert@test.com'
  user.password 'test'
  user.current_site Factory.build(:site)
  user.password_confirmation 'test'
end

Factory.define :charlie, :class => User do |user|
  user.handle 'charlie'
  user.email 'charlie@test.com'
  user.password 'test'
  user.password_confirmation 'test'
  user.current_site Factory.build(:site)
  user.admin true
end