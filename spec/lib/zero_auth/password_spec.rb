require 'spec_helper'

RSpec.describe ZeroAuth::Password do

  describe ".generate_salt" do
    it "returns a BCrypt generated salt" do
      expect(ZeroAuth::Password.generate_salt).to match(/^\$2a\$\d+\$/)
    end
  end

  describe ".create" do
    it "returns a BCrypt::Password" do
      password = ZeroAuth::Password.create("password", "salt")
      expect(password).to be_a(BCrypt::Password)
    end
  end

  describe ".compare" do
    let(:password) { ZeroAuth::Password.create("password", "salt").to_s }

    it "returns true for matching passwords" do
      result = ZeroAuth::Password.compare(password, "salt", "password")
      expect(result).to eq(true)
    end

    it "returns false for non-matching passwords" do
      result = ZeroAuth::Password.compare(password, "salt", "other")
      expect(result).to eq(false)
    end
  end
end
