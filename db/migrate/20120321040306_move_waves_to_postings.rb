class MoveWavesToPostings < ActiveRecord::Migration

  class Wave < ActiveRecord::Base
    set_table_name :waves
    set_inheritance_column nil
  end

  class SiteWave < ActiveRecord::Base
    set_table_name :sites_waves
  end

  def self.up
    ActiveRecord::Base.transaction do
      add_column :postings, :children_count,     :integer, :default => 0
      add_column :postings, :publications_count, :integer, :default => 0

      say_with_time "migrating #{Wave.count} waves" do
        Wave.find_each do |wave|
          if migrated_wave = create_wave_as_posting(wave)
            migrate_publications(wave, migrated_wave)
            migrate_sites_waves(wave, migrated_wave)
            migrate_bookmarks(wave, migrated_wave)
            migrate_personages(wave, migrated_wave)
            migrate_wave_proxies(wave, migrated_wave)
          else
            raise "Migration failure for wave #{wave[:id]}"
          end
        end
      end
      rename_table :waves, :waves_not_as_postings
      create_waves_view
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_waves_view
      delete_all_waves_as_postings
      rename_table  :waves_not_as_postings, :waves
      remove_column :postings, :children_count
      remove_column :postings, :publications_count
    end
  end

  private

  def self.migrate_publications(wave, migrated_wave)
    Publication.where(:wave_id => wave[:id]).update_all(:wave_id => migrated_wave[:id])
  end

  def self.migrate_sites_waves(wave, migrated_wave)
    SiteWave.where(:wave_id => wave[:id]).update_all(:wave_id => migrated_wave[:id])
  end

  def self.migrate_bookmarks(wave, migrated_wave)
    Bookmark.where(:wave_id => wave[:id]).update_all(:wave_id => migrated_wave[:id])
  end

  def self.migrate_personages(wave, migrated_wave)
    Personage.where(:profile_id => wave[:id]).update_all(:profile_id => migrated_wave[:id])
  end

  def self.migrate_wave_proxies(wave, migrated_wave)
    Posting::WaveProxy.where(:resource_id => wave[:id]).update_all(:resource_id => migrated_wave[:id])
  end

  def self.create_wave_as_posting(wave)
    ActiveRecord::Base.connection.execute %Q(
      INSERT INTO postings
        (type, slug, user_id, subject, body, created_at, updated_at, resource_id, resource_type, state, publications_count)
      SELECT
        type, slug, user_id, topic, description, created_at, updated_at, resource_id, resource_type, state, postings_count
      FROM waves
      WHERE waves.id = #{wave[:id]};)
    id = ActiveRecord::Base.connection.execute("SELECT LAST_INSERT_ID();").first.first
    ::Wave::Base.find(id)
  end

  def self.create_waves_view
    ActiveRecord::Base.connection.execute %Q(
      CREATE OR REPLACE VIEW waves AS SELECT * FROM `postings` WHERE `postings`.`type` LIKE 'Wave::%';)
  end

  def self.remove_waves_view
    ActiveRecord::Base.connection.execute %Q(DROP VIEW waves;)
  end

  def self.delete_all_waves_as_postings
    ActiveRecord::Base.connection.execute %Q(DELETE FROM postings WHERE type LIKE 'Wave::%';)    
  end

end
