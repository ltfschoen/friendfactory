namespace :ff do
  namespace :attachments do
    desc "Reprocess posting CLASS attachments for STYLES"
    task :reprocess => :environment do
      klass  = ENV['CLASS'].constantize
      styles = ENV['STYLES'].split(',').map { |style| style.strip.downcase.to_sym }
      raise "CLASS needs to be defined" if klass.blank?
      raise "STYLES needs to be defined" if styles.blank?      
      raise "Can't reprocess original" if styles.include?('original')      
      klass.all.each do |posting|
        if posting.respond_to?(:image)
            print "#{posting.id} "
            STDOUT.flush
          posting.send(:image).reprocess!(*styles)
        end
      end
    end

    desc "Reprocess posting image attachments geometry"
    task :geometry => :environment do
      ActiveRecord::Base.transaction do
        Posting::Base.all.each do |posting|
          if posting.respond_to?(:image)
            print "#{posting.id} "
            STDOUT.flush
            geometry = Paperclip::Geometry.from_file(posting.send(:image).path(:original))
            posting.width = geometry.width
            posting.height = geometry.height
            posting.horizontal = geometry.horizontal?
            posting.save!
          end
        end
      end
    end

    desc "Delete posting CLASS attachments for STYLE"
    task :delete => :environment do
      require 'fileutils'
      klass  = ENV['CLASS'].constantize      
      styles = ENV['STYLES'].split(',').map { |style| style.strip.downcase.to_sym }
      raise "CLASS needs to be defined" if klass.blank?      
      raise "STYLES needs to be defined" if styles.blank?
      raise "Can't delete original" if styles.include?(:original)
      klass.find_each do |posting|
        dirs = Dir[File.join('public', 'system', 'images', posting[:id].to_s, "{#{styles.join(',')}}")] 
        dirs.each { |dir| FileUtils.rm_rf dir }
      end
    end
  end
end
