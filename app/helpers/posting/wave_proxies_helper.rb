module Posting::WaveProxiesHelper
  
  def render_wave(wave)
    unless wave.nil?
      wave_type = wave.class.name.demodulize.tableize
      file_name = File.join('wave', wave_type, wave_type.singularize)
      render :partial => file_name, :object => wave
    end
  end
  
end

