namespace :spree_currency_rates do
  task load_rates: :environment do
    Spree::CurrencyRates.import_rates
  end

  task update_product_prices: :environment do
    Spree::CurrencyRates.update_product_prices
  end

  task refresh: [:load_rates, :update_product_prices]
end
