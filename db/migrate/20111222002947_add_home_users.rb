class AddHomeUsers < ActiveRecord::Migration
  def self.up
    add_column :sites, :user_id, :integer

    say_with_time 'initializing home users' do
      Site.all.each do |site|
        if wave = site.waves.published.type(Wave::Community).where(:slug => Site::DefaultHomeWaveSlug).order('created_at desc').limit(1).first
          site[:user_id] = wave[:user_id]
          site.save(:validate => false)
        end
      end
    end
  end

  def self.down
    remove_column :sites, :user_id rescue nil
  end
end
