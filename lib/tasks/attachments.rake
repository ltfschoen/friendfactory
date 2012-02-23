namespace :ff do
  namespace :attachments do
    desc "Reprocess posting attachments"
    task :reprocess => :environment do
      Posting::Base.all.each do |posting|
        if posting.respond_to?(:image)
          print "#{posting.id} "
          STDOUT.flush
          posting.send(:image).reprocess!
        end
      end
      puts "Done"
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
      puts "Done"
    end

    desc "Delete all (except the original) posting image attachments"
    task :delete => :environment do
      require 'fileutils'
      dirs = (Dir['public/system/images/*/*'] - Dir['public/system/images/*/original'])
      dirs.each { |dir| FileUtils.rm_rf dir }
    end    
  end  
end
