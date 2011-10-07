module Posting::WaveProxiesHelper
  
  def render_wave_as_posting(proxy)
    if wave = proxy.resource
      wave_type = wave.class.name.demodulize.tableize
      file_name = File.join('wave', wave_type, wave_type.singularize)
      render :partial => file_name, :object => wave, :locals => { :proxy => proxy }
    end
  end
  
end

