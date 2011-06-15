namespace :ff do
  namespace :sites do
    
    desc "Load sites. SITES=<site>,<site>"
    task :load => :'load:css'    
    namespace :load do
      task :css => :environment do
        site_names.each do |site_name|
          if site = Site.find_by_name(File.basename(site_name, '.css'))
            if site.css.blank?
              puts " * loading #{site_name}"            
              file = File.join(Rails.root, 'db', 'seeds', '*.css')
              site.update_attribute(:css, IO.read(file))
            end
          end
        end
      end
    end
    
  end
end


def site_names
  if ENV['SITES'].present?
    ENV['SITES'].split(',')
  else
    Dir[File.join(Rails.root, 'db', 'seeds', '*.css')].map { |f| File.basename(f, '.css') }.sort
  end
end

# Dir[File.join(Rails.root, 'db', 'seeds', '*.css')].each do |file|
#   if site = Site.find_by_name(File.basename(file, '.css'))
#     unless site.css.present?
#       puts " * #{File.basename(file)}"
#       site.update_attribute(:css, IO.read(file))
#     end
#   end
# end
