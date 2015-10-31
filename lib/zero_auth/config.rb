module ZeroAuth
  class Config
    attr_accessor :password_cost

    def initialize
      reset!
    end

    def reset!
      self.password_cost = 9
    end
  end
end
