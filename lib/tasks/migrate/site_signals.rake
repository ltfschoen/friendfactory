namespace :ff do
  namespace :fix do
    task :site_signals => :environment do
      migrate_site(:friskyhands) { |site| migrate_site_signal(:deafness, site) }
      migrate_site(:positivelyfrisky) { |site| migrate_site_signal(:hiv_status, site) }
      migrate_site(:friskyforces) { |site| migrate_site_signal(:military_service, site) }
      migrate_site(:dizmdayz) { |site| migrate_site_signal(:board_type, site) }
      migrate_site(:friskylolas)
      migrate_site(:friskylatinos)
    end

    def migrate_site(site)
      if site = Site.find_by_name(site.to_s)
        site.signal_categories = site_template.signal_categories.clone(:gender, :orientation, :relationship)
        yield site if block_given?
        site.save!
      end
    end
      
    def migrate_site_signal(signal_category, site)
      site.signal_categories << site_template.signal_categories.clone(signal_category)
    end
    
    def site_template
      @site_template ||= Site.template
    end
  end
end
