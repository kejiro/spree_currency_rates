RSpec.describe Spree::CurrencyRates do
  let :products do
    create_list(:product, 10) do |p|
      p.price = Kernel.rand(1_0000) / 100.0
      p.save!
    end
  end

  before do
    Spree::Config.currency = 'EUR'
    Spree::Config.supported_currencies = 'EUR,USD,GBP'
    Spree::CurrencyRates::Config.markup_in_percent = 0
  end

  before do
    Money.default_bank = Money::Bank::VariableExchange.new(Money::RatesStore::Memory.new)
    Money.default_bank.add_rate('EUR', 'USD', 1.11116)
    Money.default_bank.add_rate('EUR', 'GBP', 0.91388)

    products
  end

  it "should recalculate all prices" do
    Spree::CurrencyRates.update_product_prices

    products.each do |p|
      eur_price = p.price
      usd_price = p.amount_in('USD')
      gbp_price = p.amount_in('GBP')

      expect(usd_price).to eq((eur_price * 1.11116).round(2))
      expect(gbp_price).to eq((eur_price * 0.91388).round(2))
    end
  end

  it "should use a markup" do
    Spree::CurrencyRates::Config.markup_in_percent = 5.00

    Spree::CurrencyRates.update_product_prices

    products.each do |p|
      eur_price = p.price
      usd_price = p.amount_in('USD')
      gbp_price = p.amount_in('GBP')

      expect(usd_price).to eq((eur_price * 1.11116 * 1.05).round(2))
      expect(gbp_price).to eq((eur_price * 0.91388 * 1.05).round(2))
    end

  end
end
