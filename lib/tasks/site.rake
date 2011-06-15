namespace :ff do
  namespace :sites do

    desc "Load sites. SITES=<site>,<site>"
    task :load => [ :'load:css', :'load:signals' ]

    namespace :load do
      task :css => :environment do
        sites.each do |site|
          file = File.join(css_path, "#{site.name}.css")
          site.update_attribute(:css, IO.read(file))
        end
      end

      task :signals => :environment do
        template_site = Site.template
        sites.each do |site|
          site.signal_categories = template_site.signal_categories.clone
          site.save!
        end
      end

      def sites
        Site.find_all_by_name(site_names)
      end

      def site_names
        if ENV['SITES'].present?
          ENV['SITES'].split(',')
        else
          site_names = Dir[File.join(css_path, '*.css')].map { |f| File.basename(f, '.css') }
          site_names.sort - [ Site::TemplateSiteName ]
        end
      end
      
      def css_path
        File.join(Rails.root, 'db', 'seeds')
      end
    end

  end
end
