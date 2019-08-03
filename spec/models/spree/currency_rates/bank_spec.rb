RSpec.describe Spree::CurrencyRates::Bank do
  before do
    Money.default_bank = subject
  end

  it "should exchange one currency for another" do
    create(:currency_rate, {base_currency: 'EUR', currency: 'USD', rate: 0.5})

    eur = Money.new(5.00, 'EUR')
    expect(eur.as_us_dollar).to eq(Money.new(2.5, 'USD'))
  end

  it "should fail when missing a rate" do
    eur = Money.new(5.00, 'EUR')
    expect { eur.as_us_dollar }.to raise_error(Money::Bank::UnknownRate)
  end

  it "should return the same value when converting to same currency" do
    eur = Money.new(5.00, 'EUR')
    actual = subject.exchange_with(eur, 'EUR')
    expect(actual).to eq(eur)
  end

  it "should use a custom rounding" do
    create(:currency_rate, {base_currency: 'EUR', currency: 'USD', rate: 0.5})

    eur = Money.new(5.00, 'EUR')

    actual = subject.exchange_with(eur, 'USD') { |a| a.round }
    expect(actual).to eq(Money.new(3.00, 'USD'))
  end
end