require 'spec_helper'

RSpec.describe Spree::CurrencyRates::Source do
  context "#sources" do
    it "should return all defined sources" do
      sources = Spree::CurrencyRates::Source.sources

      expect(sources).to include(Spree::CurrencyRates::Source::Ecb)
      expect(sources).to include(Spree::CurrencyRates::Source::Fixer)
    end
  end
end