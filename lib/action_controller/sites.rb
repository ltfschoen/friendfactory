module ActionController
  class Base
    cattr_accessor :localhost
  end
  module Sites    
    def self.included(base)      
      base.class_inheritable_accessor :sites_dir
      base.sites_dir = File.join(Rails.root, 'app', 'sites')
    
      extract = /^#{Regexp.quote(base.sites_dir)}\/?(.*)_site.rb$/
      site_names = Dir["#{base.sites_dir}/**/*_site.rb"].map { |file| file.sub extract, '\1' }  
        
      base.class_inheritable_accessor :sites
      base.sites = site_names.inject(Hash.new(ApplicationSite.new)) do |memo, site_name|    
        site = (site_name + '_site').classify.constantize.new
        memo.merge(site_name => site)
      end
    end
    
    def current_site
      site_name = request.domain && request.domain.gsub(/\..*$/, '')
      if [ nil, 'localhost' ].include?(site_name)
        site_name = ActionController::Base.localhost 
      end
      ApplicationController.sites[site_name]
    end            
  end  
end
