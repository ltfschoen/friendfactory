namespace :ff do
  namespace :fix do
    task :ribbons => :environment do

      def create_signup_posting(personage, created_at)
        posting = Posting::Persona.new
        posting.user = personage
        posting.created_at = created_at
        posting.updated_at = created_at
        posting.new_signup = true
        posting.state = :published
        posting.save!
        posting
      end

      def create_publication(collection, posting, created_at = nil)
        created_at ||= posting.created_at
        publication = collection.build
        publication.created_at = created_at
        publication.updated_at = created_at
        publication.resource = posting
        publication.save!
      end

      def avatar_on_wave(wave, avatar_id)
        Publication.exists?(:wave_id => wave[:id], :resource_id => avatar_id)
      end

      def unpublish_related_avatar_postings(wave, posting, republish_window)
        wave.postings.
            type(Posting::Avatar).
            published.
            where(:created_at => (posting.created_at - republish_window)...posting.created_at).
            where(:user_id => posting[:user_id]).
            where('`postings`.`id` <> ?', posting[:id]).
            map(&:unpublish!)
      end

      def create_signup_postings
        ActiveRecord::Base.record_timestamps = false
        Personage.includes(:user => :site).each do |personage|
          created_at = personage.persona.created_at
          posting = create_signup_posting(personage, created_at)
          [ personage.site.home_wave.publications, personage.profile.publications ].each do |collection|
            create_publication(collection, posting, created_at)
          end
        end
        ActiveRecord::Base.record_timestamps = true
      end

      def create_avatar_publications
        ActiveRecord::Base.record_timestamps = false
        Persona::Person.includes(:user => { :user => :site }).includes(:avatar).each do |person|
          avatar = person.avatar
          unless avatar.silhouette?
            personage = person.user
            [ personage.site.home_wave, personage.profile ].each do |wave|
              unless avatar_on_wave(wave, person[:avatar_id])
                create_publication(wave.publications, avatar)
                unpublish_related_avatar_postings(wave, avatar, Wave::Profile::RepublishWindow)
              end
            end
          end
        end
        ActiveRecord::Base.record_timestamps = true
      end

      Personage.transaction do
        create_signup_postings
        create_avatar_publications
      end
    end
  end
end
