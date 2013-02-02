module Paperclip
  module Interpolations
    def assets_root attachment, style_name
      assets_root = ENV["FRIENDFACTORY_ASSETS_ROOT"] || (File.join Rails.public_path, "system")
      Rails.logger.info "assets root is #{assets_root}"
      assets_root
    end
  end
end
