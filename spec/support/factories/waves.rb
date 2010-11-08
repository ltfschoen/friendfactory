Factory.define :wave, :class => Wave::Base do |wave|
  wave.slug Waves::BaseController::DefaultWaveSlug
end