namespace :ff do
  namespace :heroku do
    def models
     [[ Asset::Image, :asset ], [ Posting::Avatar, :image ], [ Posting::Photo, :image ]]
    end

    def credentials?
      ENV["AWS_ACCESS_KEY_ID"].present? && ENV["AWS_SECRET_ACCESS_KEY"].present?
    end

    def bucket?
      ENV["S3_BUCKET_NAME"].present?
    end

    task :s3 => :environment do
      exit unless credentials? && bucket?
      s3 = AWS::S3.new \
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]

      bucket_name = ENV["S3_BUCKET_NAME"]
      bucket = s3.buckets[bucket_name]
      write_options = {
        :acl => "RAP"
      }

      models.each do |model, attachment|
        idx = 0
        print "#{model.name} "
        styles = [ :original ]
        model.first.send(attachment).styles.each do |style|
          styles.push style[0]
        end

        model.all.each_with_index do |model, idx|
          styles.each do |style|
            path = model.send(attachment).path(style).sub(%r{^/},'')
            object = bucket.objects[path]
            object.write Rails.root.join('public', 'system', path), write_options
          end
          idx += 1
          print idx if idx % 100 == 0
        end
        puts
      end
    end
  end
end
