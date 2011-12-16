class AddHomeWaveToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :home_wave_id, :integer rescue nil

    say_with_time 'initializing home wave' do
      Site.all.each do |site|
        if wave = site.waves.type(Wave::Community).where(:slug => Site::DefaultHomeWaveSlug).order('created_at desc').limit(1).first
          site.update_attribute(:home_wave_id, wave.id) 
        else
          site.create_home_wave && site.save!
        end
      end
    end
  end

  def self.down
    remove_column :sites, :home_wave_id rescue nil
  end
end
