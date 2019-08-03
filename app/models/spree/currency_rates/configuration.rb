module Spree
  module CurrencyRates
    class Configuration < Spree::Preferences::Configuration
      preference :source, :string
      preference :api_key, :string
      preference :markup_in_percent, :decimal, default: 0

      def bank
        @bank ||= Spree::CurrencyRates::Bank.new
      end

      attr_writer :bank
    end
  end
end