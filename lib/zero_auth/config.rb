module ZeroAuth
  class Config
    # @return [Integer] The cost param when generating BCrypt passwords.
    #   Defaults to 9.
    attr_accessor :password_cost

    def initialize
      reset!
    end

    # Resets the current configuration values to their defaults.
    #
    def reset!
      self.password_cost = 9
    end
  end
end
