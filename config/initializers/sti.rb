if Rails.env.development?
  Dir[File.join(Rails.root, 'app', 'models', '{posting,wave}', '*.rb')].each do |file|
    require_dependency(file)
  end
end
