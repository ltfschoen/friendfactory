Factory.define :wave, :class => Wave::Base do |wave|
  wave.slug Wave::CommunitiesController::DefaultWaveSlug
end
