require 'spec_helper'

RSpec.describe ZeroAuth::Config do

  let(:config) { described_class.new }

  describe "#reset!" do
    it "resets the configuration" do
      old_cost = config.password_cost
      config.password_cost = 25
      config.reset!
      expect(config.password_cost).to eq(old_cost)
    end
  end

  shared_examples_for :config_attribute do |config_name, default_value|
    describe "##{config_name}" do
      it "has a default_value of #{default_value.inspect}" do
        expect(config.send(config_name)).to eq(default_value)
      end

      it "can be set to a new value" do
        config.send("#{config_name}=", :test)
        expect(config.send(config_name)).to eq(:test)
      end
    end
  end

  include_examples :config_attribute, :password_cost, 9
end
