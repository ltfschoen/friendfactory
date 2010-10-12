class UnauthorizedException < StandardError
  attr_reader :user
  def initialize(user)
    @user = user
  end
end

class ConfigurationException < RuntimeError
end
