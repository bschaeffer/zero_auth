require 'spec_helper'

RSpec.describe ZeroAuth::Utils do

  describe ".secure_compare" do
    it "returns true for equal values" do
      expect(ZeroAuth::Utils.secure_compare("password", "password")).to eq(true)
    end

    it "returns false for non-equal values" do
      expect(ZeroAuth::Utils.secure_compare("password", "other")).to eq(false)
    end

    it "returns false for empty strings" do
      expect(ZeroAuth::Utils.secure_compare("password", "")).to eq(false)
      expect(ZeroAuth::Utils.secure_compare("", "password")).to eq(false)
      expect(ZeroAuth::Utils.secure_compare("", "")).to eq(false)
    end

    it "returns false for nil values" do
      expect(ZeroAuth::Utils.secure_compare("password", nil)).to eq(false)
      expect(ZeroAuth::Utils.secure_compare(nil, "password")).to eq(false)
      expect(ZeroAuth::Utils.secure_compare(nil, nil)).to eq(false)
    end
  end
end
