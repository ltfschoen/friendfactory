require 'rake'

class AddDimensionsToPosting < ActiveRecord::Migration
  def self.up  
    add_column :postings, :width, :integer
    add_column :postings, :height, :integer
    add_column :postings, :horizontal, :boolean
    
    puts '-- ff:attachments:reprocess!'
    Rake::Task[:'ff:attachments:reprocess!'].invoke
    
    puts '-- ff:attachments:geometry!'
    Rake::Task[:'ff:attachments:geometry!'].invoke    

    puts '-- update default wave slug'
    update_default_wave('shared', ::WavesController::DefaultWaveSlug)
  end

  def self.down
    remove_column :postings, :width rescue nil
    remove_column :postings, :height rescue nil
    remove_column :postings, :horizontal rescue nil
    update_default_wave(::WavesController::DefaultWaveSlug, 'shared')
  end
end

def update_default_wave(old_slug, new_slug)
  wave = Wave::Base.find_by_slug(old_slug)
  if wave.present?
    wave.slug = new_slug
    wave.save
  end  
end
