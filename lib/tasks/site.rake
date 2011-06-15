namespace :ff do
  namespace :sites do
    
    desc "Load sites. SITES=<site>,<site>"
    task :load => :'load:css'
    
    namespace :load do
      task :css => :environment do
        site_names.each do |site_name|
          if site = Site.find_by_name(site_name)
            file = File.join(css_path, "#{site_name}.css")
            puts "#{site_name}=>#{file}"
            site.update_attribute(:css, IO.read(file))
          end
        end
      end

      def site_names
        if ENV['SITES'].present?
          ENV['SITES'].split(',')
        else
          Dir[File.join(css_path, '*.css')].map { |f| File.basename(f, '.css') }.sort
        end
      end
      
      def css_path
        File.join(Rails.root, 'db', 'seeds')
      end
    end
    
  end
end
