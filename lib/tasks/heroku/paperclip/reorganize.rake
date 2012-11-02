namespace :ff do
  namespace :heroku do
    namespace :paperclip do
      task :reorganize => [ :environment ] do
        attachments_root_directory = Rails.root.join 'public', 'system'
        models = {
          "Asset::Image" => [ "asset", "images", "assets" ],
          "Posting::Avatar" => [ "posting", "avatars", "images" ],
          "Posting::Photo" => [ "posting", "photos", "images" ]
        }

        models.each do |model, model_path|

          model = model.constantize
          postgres_klass = Class.new ActiveRecord::Base do
            set_table_name model.table_name
            establish_connection(
              adapter: "postgresql",
              encoding: "unicode",
              database: "friendfactory_development",
              pool: 5,
              username: "friendfactory",
              password: "ffu123"
            )
            underscored_model = model.name.underscore
            idx = 0
            print "#{model} (#{model.count}) "
            model.all.each do |row|
              idx += 1
              print "#{idx} " if idx % 1000 == 0
              id_fragments = ("%09d" % row[:id]).scan(/.../)
              original_directory = File.join attachments_root_directory, model_path.last, row[:id].to_s
              attachment_directory = File.join attachments_root_directory, *model_path, *id_fragments
              FileUtils.mkdir_p File.join attachment_directory
              # puts "#{original_directory} -> #{attachment_directory}"
              FileUtils.cp_r File.join(original_directory, '.'), attachment_directory
            end
            puts if idx > 0
          end
        end
      end
    end
  end
end
