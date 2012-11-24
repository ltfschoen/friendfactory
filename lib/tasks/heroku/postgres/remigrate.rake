namespace :ff do
  namespace :heroku do
    namespace :postgres do
      task :remigrate => [ :environment, :postgres_klass ] do
        remigrations.each do |sql|
          begin
            print sql
            execute_sql sql
          rescue
            print " ERROR!"
          ensure
            puts
          end
        end
      end

      def execute_sql sql
        postgres_klass = postgres_klass "users" # Any model will do
        postgres_klass.connection.execute sql
      end

      def remigrations
        [
          %Q{alter table personas alter column emailable type boolean using case emailable when 0 then false when 1 then true else null end;},
          %Q{alter table personas alter column emailable set default false; -- really??},
          %Q{alter table personas alter column featured type boolean using case featured when 0 then false when 1 then true else null end;},
          %Q{alter table personas alter column featured set default false;},
          %Q{alter table personages alter column "default" type boolean using case "default" when 0 then false when 1 then true else null end;},
          %Q{alter table personages alter column "default" set default false;},
          %Q{-- alter table postings alter column active type boolean using case active when 0 then false when 1 then true else null end;},
          %Q{drop view waves;},
          %Q{alter table postings alter column horizontal type boolean using case horizontal when 0 then false when 1 then true else null end;},
          %Q{alter table resource_events alter column private type boolean using case private when 0 then false when 1 then true else null end;},
          %Q{alter table resource_events alter column rsvp type boolean using case rsvp when 0 then false when 1 then true else null end;},
          %Q{alter table resource_links alter column safe type boolean using case safe when 0 then false when 1 then true else null end;},
          %Q{alter table sites alter column launch type boolean using case launch when 0 then false when 1 then true else null end;},
          %Q{alter table sites alter column launch set default false;},
          %Q{alter table sites alter column invite_only type boolean using case invite_only when 0 then false when 1 then true else null end;},
          %Q{alter table sites alter column invite_only set default false;},
          %Q{-- alter table users alter column emailable type boolean using case emailable when 0 then false when 1 then true else null end;},
          %Q{alter table users alter column admin type boolean using case admin when 0 then false when 1 then true else null end;},
          %Q{alter table users alter column admin set default false;},
          %Q{create view waves as select * from postings where "type" ilike 'Wave::%';}
        ]
      end
    end
  end
end
