namespace :ff do
  namespace :fix do
    task :randomize_file_names => :environment do
      Posting::Avatar.all.each do |posting|
        extension = File.extname(posting.image_file_name).downcase
        new_file_name = "#{ActiveSupport::SecureRandom.hex(16)}#{extension}"
        styles = posting.image.styles.keys + [ :original ]
        styles.each do |style|          
          path = posting.image.path(style)
          FileUtils.move(path, File.join(File.dirname(path), new_file_name))          
        end
        posting.image_file_name = new_file_name
        posting.save!
      end
    end
  end
end
