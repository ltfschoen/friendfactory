namespace :ff do
  namespace :db do
    desc "Load all friskyfactory data"
    task :load => [ :'spec:db:fixtures:load', :'spec:db:fixtures:images:load', :'ts:rebuild' ]    
  end
end
