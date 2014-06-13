module ZeroAuth
  class Utils

    # Stolen from `Devise.secure_compare`:
    # https://github.com/plataformatec/devise/blob/master/test/devise_test.rb
    def self.secure_compare(a, b)
      return false if empty?(a) || empty?(b) || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    def self.empty?(v) # :nodoc:
      v.respond_to?(:empty?) ? v.empty? : !v
    end
  end
end
