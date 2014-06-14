require "zero_auth/version"

module ZeroAuth
  autoload :Utils, 'zero_auth/utils'
  autoload :Password, 'zero_auth/password'

  module Model
    autoload :Password, 'zero_auth/model/password'
  end

  # Exception raised througout the library when a method expected to
  # perform some type of authentication on user supplied parameters cannot be
  # authenticated.
  #
  class Unauthorized < StandardError; end
end
