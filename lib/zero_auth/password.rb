require 'bcrypt'
module ZeroAuth

  # Provides helper methods for generating and comparing BCrypt passwords
  #
  class Password

    # Generates a password salt using `BCrypt::Engine.generate_salt`
    #
    # @return [String] the password salt
    #
    def self.generate_salt
      BCrypt::Engine.generate_salt
    end

    # Generates a `BCrypt::Password` using they {ZeroAuth::Config#password_cost}
    # configuration value.
    #
    # @param password [String] the given password
    # @param salt [Sting] the password salt
    #
    # @return [BCrypt::Password]
    #
    def self.create(password, salt)
      cost = ZeroAuth.config.password_cost
      BCrypt::Password.create("#{password}#{salt}", cost: cost)
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
