FactoryBot.define do
  factory :currency_rate, class: Spree::CurrencyRate do
    base_currency {FFaker::Currency.code}
    currency {FFaker::Currency.code}
    rate {FFaker::Random.rand(2.0)}
  end
end