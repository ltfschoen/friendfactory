namespace :ff do
  namespace :sites do

    desc "Load sites from seed css or SITES=<site>,<site>"
    task :load => [ :'load:css', :'load:signals' ]

    namespace :load do
      desc "Load css from seed css"
      task :css => :environment do
        sites.each do |site|
          file = File.join(css_path, "#{site.name}.css")
          site.update_attribute(:css, IO.read(file))
        end
      end

      desc "Load signals from template"
      task :signals => :environment do
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
      
      def template_site
        @template_site ||= Site.template
      end
    end
  end
end
