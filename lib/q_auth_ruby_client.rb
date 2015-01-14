require "q_auth_ruby_client/engine"
require "q_auth_ruby_client/configuration"

module QAuthRubyClient
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
