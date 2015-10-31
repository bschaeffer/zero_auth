require 'thread'
require 'zero_auth/version'
require 'zero_auth/config'

module ZeroAuth
  autoload :Utils, 'zero_auth/utils'
  autoload :Password, 'zero_auth/password'

  module Model
    autoload :Password, 'zero_auth/model/password'
  end

  def self.config
    Thread.current[:zero_auth_config] ||= Config.new
  end

  def self.configure
    yield config
  end

  # Exception raised througout the library when a method expected to
  # perform some type of authentication on user supplied parameters cannot be
  # authenticated.
  #
  class Unauthorized < StandardError; end
end
