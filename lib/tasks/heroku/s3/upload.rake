namespace :ff do
  namespace :heroku do
    namespace :s3 do
      task :upload, [ :model ] => :environment do |task, args|
        unless credentials? && bucket?
          puts "Need credentials and bucket"
          exit
        end

        s3 = AWS::S3.new \
          access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]

        models = {
          assets: [ Asset::Image, :asset ],
          avatars: [ Posting::Avatar, :image ],
          photos: [ Posting::Photo, :image ]
        }

        model, attachment = models[args[:model].to_sym]
        unless model.present?
          puts "Unknown model: #{args["model"]}, use #{models.keys.to_setence('or')}"
        end

        bucket_name = ENV["S3_BUCKET_NAME"]
        bucket = s3.buckets[bucket_name]

        print "#{model.name} (#{model.count}) "
        styles = [ :original ]
        model.first.send(attachment).styles.each do |style|
          styles.push style[0]
        end

        model.all.each_with_index do |model, idx|
          styles.each do |style|
            path = model.send(attachment).path(style).sub(%r{^/},'')
            object = bucket.objects[path]
            content_type = model.send(attachment).content_type
            object.write Rails.root.join('public', 'system', path), { :acl => :public_read, :content_type => content_type }
          end
          print "#{idx} " if idx > 0 && idx % 100 == 0
        end
        puts
      end

      def credentials?
        ENV["AWS_ACCESS_KEY_ID"].present? && ENV["AWS_SECRET_ACCESS_KEY"].present?
      end

      def bucket?
        ENV["S3_BUCKET_NAME"].present?
      end
    end
  end
end
