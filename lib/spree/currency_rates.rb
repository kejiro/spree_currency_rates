require 'spree_core'
require 'spree_extension'

module Spree
  module CurrencyRates
    def self.supported_currencies
      Spree::Config[:supported_currencies].split(',').map { |code| ::Money::Currency.find(code.strip) }
    end

    def self.config
      yield(Spree::CurrencyRates::Config)
    end

    def self.update_product_prices
      markup = Spree::CurrencyRates::Config.markup_in_percent || 0
      rounding_method = nil
      rounding_method = Proc.new { |v| v * (1 + markup / 100.0) } unless markup == 0
      puts "markup: #{markup}"

      Spree::Variant.includes(:default_price).all.each do |p|
        default_money = p.default_price.money.money

        supported_currencies.each do |currency|
          next if currency == default_money.currency
          price = p.price_in(currency.iso_code)

          price.price = default_money.exchange_to(currency, &rounding_method).to_d
          price.save! if price.new_record? && price.price || !price.new_record? && price.changed?
        end
      end
    end
  end
end
require 'spree_currency_rates/engine'
require 'spree_currency_rates/version'
