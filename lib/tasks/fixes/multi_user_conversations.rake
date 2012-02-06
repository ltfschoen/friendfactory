namespace :ff do
  namespace :fix do
    task :multi_user_conversations => :environment do

      def transaction_without_conversation_timestamps
        Wave::Conversation.record_timestamps = false
        ActiveRecord::Base.transaction { yield }
        Wave::Conversation.record_timestamps = true
      end

      def conversations
        @conversations ||= begin
          Wave::Conversation.includes(:sites).includes(:user => { :user => :site }).all
        end
      end

      def extract_site(wave)
        wave.sites.first
      end

      ### One Site Only

      def check_for_conversation_on_one_site(wave)
        if wave.sites.length > 1
          puts "conversation:#{wave[:id]} has two sites"
          raise ActiveRecord::Rollback
        end
      end

      ### Recipient Presence

      def check_for_recipient_presence(wave)
        if wave.recipient.nil?
          puts "conversation:#{wave[:id]} has no recipient"
          raise ActiveRecord::Rollback
        end
      end

      ### User Site Agreement

      def check_for_user_site_agreement(wave)
        site = extract_site(wave)
        user = wave.user
        if site[:id] != user.user_record[:site_id]
          puts "conversation:#{wave[:id]} site and user-record site don't agree"
          raise ActiveRecord::Rollback
        end
      end

      ### Recipient Site Agreement

      def check_for_recipient_site_agreement(wave)
        recipient = wave.recipient
        site = extract_site(wave)
        user = wave.user
        if site[:id] != recipient.user_record[:site_id]
          puts "conversation:#{wave[:id]}/#{site.name} site and recipient user-record site don't agree"
          puts "  from:      id:#{user[:id]} #{user.email}/#{user.site.name}"
          puts "  recipient: id:#{recipient[:id]} #{recipient.email}/#{recipient.site.name}"
          yield wave if block_given?
        end
      end

      def fix_wave_for_recipient_site_agreement(wave)
        site = extract_site(wave)
        recipient = wave.recipient
        if correct_recipient_user_record = site.users.find_by_email(recipient.email)
          correct_recipient_personage = correct_recipient_user_record.default_personage
          puts "  should be: id:#{correct_recipient_personage[:id]} #{correct_recipient_personage.email}/#{correct_recipient_personage.site.name}"
          wave.recipient = correct_recipient_personage
          wave.save!
        else
          puts "  couldn't find correct recipient user-record for #{recipient.email} on site #{site.name}"
          raise ActiveRecord::Rollback
        end
      end

      ### Conversation Symmetry

      def check_for_conversation_symmetry(waves)
        waves.each do |wave|
          site = extract_site(wave)
          user = wave.user
          recipient = wave.recipient
          if recipient_wave = recipient.conversation_with(user, site)
            if (wave.user != recipient_wave.recipient) || (wave.recipient != recipient_wave.user)
              puts "conversation:#{wave[:id]} is not symmetric with conversation:#{recipient_wave[:id]}"
              raise ActiveRecord::Rollback
            end
          end
        end
      end

      ### Commit

      def commit
        if 'false' == ENV['COMMIT']
          puts "rollback"
          ActiveRecord::Rollback
        else
          puts "commit"
        end
      end

      transaction_without_conversation_timestamps do
        fixed_waves_count = conversations.inject(0) do |memo, wave|
          check_for_conversation_on_one_site(wave)
          check_for_recipient_presence(wave)
          check_for_user_site_agreement(wave)
          check_for_recipient_site_agreement(wave) do |wave_to_fix|
            fix_wave_for_recipient_site_agreement(wave_to_fix)
            memo += 1
          end
          memo
        end
        check_for_conversation_symmetry(conversations)
        puts "#{fixed_waves_count} fixed"
        commit
      end
    end
  end
end
