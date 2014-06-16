require 'spec_helper'

RSpec.describe ZeroAuth::Model::Password do
  class User
    include ZeroAuth::Model::Password
    attr_accessor :password_salt, :password_hash
  end

  class ArUser < User
    def new_record?
      false
    end
  end

  let(:user) { User.new }
  before { user.password = "password" }

  describe "#password=" do
    it "sets the hash and salt to nil given a nil password" do
      user.password = nil
      expect(user.password_salt).to eq(nil)
      expect(user.password_hash).to eq(nil)
    end

    it "sets the hash and salt given a non-nil password" do
      user.password = "password"
      salt = user.password_salt
      hash = user.password_hash

      expect(salt).to_not be_empty
      expect(hash).to_not be_empty

      expected_salt = ZeroAuth::Password.generate_salt
      expect(salt.length).to eq(expected_salt.length)

      hash_result = ZeroAuth::Password.compare(hash, salt, "password")
      expect(hash_result).to eq(true)
    end
  end

  describe "#has_password?" do
    it "returns true given a valid password" do
      expect(user.has_password?("password")).to eq(true)
    end

    it "returns false for an invalid password" do
      expect(user.has_password?("test")).to eq(false)
    end
  end

  describe "#authenticate!" do
    it "raises a ZeroAuth::Unauthorized error for an invalid password" do
      user.password = "password"
      expect{user.authenticate!("other")}.to raise_error(ZeroAuth::Unauthorized)
    end

    it "returns true for a valid password" do
      user.password = "password"
      expect(user.authenticate!("password")).to eq(true)
    end
  end

  describe "#requires_password?" do
    let(:password) { nil }
    before { user.password = password }
    subject { user.requires_password? }

    context "when the object is not a new #new_record?" do
      context "and its password_hash is empty" do
        it { is_expected.to eq(false) }
      end

      context "and its password is not-empty" do
        let(:password) { "password" }
        it { is_expected.to eq(true) }
      end
    end

    context "when the object is a #new_record?" do
      let(:user) { ArUser.new }
      before { allow(user).to receive(:new_record?) { true } }

      it { is_expected.to eq(true) }
    end
  end
end
