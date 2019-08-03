require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Spree::CurrencyRates::Source::Ecb do
  before do
    Spree::Config.currency = 'EUR'
  end

  it "should give an error with unsupported currency" do
    Spree::Config.currency = 'USD'
    expect { subject.import }.to raise_error(Spree::CurrencyRates::UnsupportedCurrencyError)
  end

  it "should request the currency rates" do
    expected_result = File.read("spec/fixtures/eurofxref-daily.xml")
    stub = stub_request(:get, "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml").to_return(body: expected_result, status: 200)
    subject.import
    expect(stub).to have_been_requested
  end

  it "should save the supported currencies to the db" do
    Spree::Config.supported_currencies = 'EUR,USD,GBP'
    rates = {'USD': BigDecimal('1.1138'), 'GBP': BigDecimal('0.89633')}

    body = File.read('spec/fixtures/eurofxref-daily.xml')
    stub_request(:get, 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml').to_return(body: body, status: 200)

    subject.import

    cnt = Spree::CurrencyRate.where(base_currency: Spree::Config.currency).where.not(currency: Spree::Config.supported_currencies.split(',')).count
    expect(cnt).to be(0)

    rates.each do |k, v|
      rate = Spree::CurrencyRate.find_by_base_currency_and_currency(Spree::Config.currency, k)
      expect(rate).to_not be_nil
      expect(rate.rate).to eq(v)
    end
  end
end