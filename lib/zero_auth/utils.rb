require 'bcrypt'

module ZeroAuth

  # Provides general helper methods used throughout the ZeroAuth library.
  #
  class Utils

    # Uses a "constant time" comparison algorithm I would never have thought
    # about so I copied it line for line from `Devise.secure_compare`:
    #
    # https://github.com/plataformatec/devise/blob/11c88754791322c8c4c5c123149f5435eda3b932/lib/devise.rb#L481
    #
    # @params a [String] first string to compare
    # @params second [String] second string to compare
    #
    # @return [Boolean] true if they are equal, false if they aren't
    #
    def self.secure_compare(a, b)
      return false if empty?(a) || empty?(b) || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    #
    # @!visibility private
    def self.empty?(v)
      v.respond_to?(:empty?) ? v.empty? : !v
    end
  end
end
