namespace :ff do
  namespace :heroku do
    namespace :paperclip do
      task :reorganize => [ :environment ] do
        attachments_root_directory = Rails.root.join 'public', 'system'
        models = {
          Asset::Image => [ "asset", "images", "assets" ],
          Posting::Avatar => [ "posting", "avatars", "images" ],
          Posting::Photo => [ "posting", "photos", "images" ]
        }

        models.each do |model, model_path|
          print "#{model} (#{model.count}) "
          model.all.each_with_index do |row, idx|
            print "#{idx} " if idx > 0 && idx % 1000 == 0
            id_fragments = ("%09d" % row[:id]).scan(/.../)
            original_directory = File.join attachments_root_directory, model_path.last, row[:id].to_s
            attachment_directory = File.join attachments_root_directory, *model_path, *id_fragments
            FileUtils.mkdir_p File.join attachment_directory
            FileUtils.cp_r File.join(original_directory, '.'), attachment_directory
          end
          puts
        end
      end
    end
  end
end
