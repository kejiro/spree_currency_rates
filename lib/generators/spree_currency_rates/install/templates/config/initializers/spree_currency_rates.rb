Spree::CurrencyRates.config do |config|
  config.source = "Spree::CurrencyRates::Source::Ecb"
  # Set for sources that require a api key
  # config.api_key =

  # Set the amount a conversion should be marked up with
  # config.markup_in_percent = 3
end