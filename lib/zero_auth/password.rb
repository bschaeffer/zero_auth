require 'bcrypt'

module ZeroAuth
  class Password

    # @return [String] a salt created by `BCrypt::Engine.generate_salt`
    #
    def self.generate_salt
      BCrypt::Engine.generate_salt
    end

    # Generates a `BCrypt::Password` with a hard-coded cost of **9** (which
    # will probably change soon).
    #
    # @param password [String] the given password
    # @param salt [Sting] the password salt
    #
    # @return [BCrypt::Password]
    #
    def self.create(password, salt)
      BCrypt::Password.create("#{password}#{salt}", cost: 9)
    end

    # Compares a given encrypted password and the salt used to generate it with
    # an unencrypted_password. Uses {ZeroAuth::Utils.secure_compare}.
    #
    # @param encrypted [String] the encrypted password
    # @param salt [String] the salt used to generate that password
    # @param unencrypted [String] the plain text password to compare
    #
    # @return [Boolean] true if they are equal, false if they aren't
    #
    def self.compare(encrypted, salt, unencrypted)
      bcrypt = BCrypt::Password.new(encrypted)
      password = BCrypt::Engine.hash_secret("#{unencrypted}#{salt}", bcrypt.salt)
      ZeroAuth::Utils.secure_compare(password, encrypted)
    end
  end
end
