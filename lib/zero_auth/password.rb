require 'bcrypt'

module ZeroAuth
  class Password

    def self.generate_salt
      BCrypt::Engine.generate_salt
    end

    def self.create(password, salt)
      BCrypt::Password.create("#{password}#{salt}", cost: 9)
    end

    def self.compare(encrypted, salt, test)
      bcrypt = BCrypt::Password.new(encrypted)
      password = BCrypt::Engine.hash_secret("#{test}#{salt}", bcrypt.salt)
      ZeroAuth::Utils.secure_compare(password, encrypted)
    end
  end
end
