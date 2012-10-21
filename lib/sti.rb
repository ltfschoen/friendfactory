Dir[File.join(Rails.root, 'app', 'models', '{posting,wave}', '*.rb')].each do |file|
  require_dependency file rescue nil
end
