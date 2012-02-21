namespace :ff do
  namespace :fix do
    task :posting_text_subjects => :environment do
      ActiveRecord::Base.record_timestamps = false
      Posting::Base.transaction do
        Posting::Text.all.each do |text|
          subject = text.subject
          body = text.body
          if subject.present?
            text.body = subject.length < 30 ? "# #{subject}\n\n#{body}" : "#{subject}\n\n#{body}"
          else
            text.body = body
          end
          text.save!
        end
      end
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
