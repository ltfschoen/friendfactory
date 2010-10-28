Factory.define :wave, :class => Wave::Base do |wave|
  wave.slug WavesController::DefaultWaveSlug
end