namespace :ff do
  namespace :fix do

    # One-time fix to update profile signals (in UserInfo)
    # from ordinals to signal_ids

    task :profile_signals => :environment do      
      # These constants all originally from UserInfo
      Gender          = [ :gender_male, :gender_female, :gender_trans ]
      Orientation     = [ :orientation_gay, :orientation_lesbian, :orientation_straight, :orientation_bisexual, :orientation_transexual ]
      Relationship    = [ :relationship_single, :relationship_in_relationship, :relationship_married, :relationship_looking_for_relationship, :relationship_friends_only ]
      Deafness        = [ :deafness_deaf, :deafness_hard_of_hearing, :deafness_hearing, :deafness_coda ]
      HivStatus       = [ :hiv_status_positive, :hiv_status_negative, :hiv_status_dont_know ]
      MilitaryService = [ :military_service_navy, :military_service_airforce, :military_service_army, :military_service_guard, :military_service_reserve, :military_service_marine ]
      BoardType       = [ :board_type_surf, :board_type_snow, :board_type_skate ]

      migrate_profiles(:friskyhands) { |resource| migrate_signal(:deafness, resource) }
      migrate_profiles(:positivelyfrisky) { |resource| migrate_signal(:hiv_status, resource) }
      migrate_profiles(:friskyforces) { |resource| migrate_signal(:military_service, resource) }
      migrate_profiles(:dizmdayz) { |resource| migrate_signal(:board_type, resource) }
    end    

    def migrate_profiles(site_name)
      if site = Site.find_by_name(site_name.to_s)
        site.waves.type(Wave::Profile).each do |profile|
          if resource = profile.resource
            migrate_signal(:gender, resource)
            migrate_signal(:orientation, resource)
            migrate_signal(:relationship, resource)
            yield resource if block_given?
          end
        end
      end
    end

    def migrate_signal(old_signal_name, resource)
      if map = self.class.const_get(old_signal_name.to_s.pluralize.classify, false)
        if signal_ordinal = resource.send(old_signal_name.downcase)
          new_signal_name = map[signal_ordinal - 1]
          resource.update_attribute(:"#{old_signal_name}_id", signals[new_signal_name])
        end
      end  
    end

    def zipify(ary)
      ary.zip(1..ary.length)
    end

    def signals
      @signals ||= begin
        Signal::Base.all.inject({}) do |memo, sig|  
          memo[sig.name.to_sym] = sig.id
          memo
        end
      end
    end
  end
end

