require 'thread'
require 'zero_auth/version'
require 'zero_auth/config'

# Namespace for the ZeroAuth library
# @since 0.0.1
#
module ZeroAuth
  autoload :Utils, 'zero_auth/utils'
  autoload :Password, 'zero_auth/password'

  module Model
    autoload :Password, 'zero_auth/model/password'
  end

  # The current {ZeroAuth::Config} object for the thread.
  #
  # @return [ZeroAuth::Config]
  #
  def self.config
    Thread.current[:zero_auth_config] ||= Config.new
  end

  # Enables configuration of the ZeroAuth library.
  #
  # @yieldparam [ZeroAuth::Config] config
  #
  def self.configure
    yield config
  end

  # Exception raised througout the library when a method expected to
  # perform some type of authentication on user supplied parameters cannot be
  # authenticated.
  #
  class Unauthorized < StandardError; end
end
