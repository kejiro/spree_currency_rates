module Spree
  module CurrencyRates
    class Source
      attr_accessor :api_url

      def self.sources
        Rails.application.config.spree_currency_rates.sources
      end

      def supported_base_currencies
        []
      end

      def import
        raise NotImplementedError
      end

      protected

      def get_base_currency
        Spree::Config.currency
      end

      def get_supported_currencies
        Spree::Config.supported_currencies&.split(',') || []
      end

      def fetch
        raise NotImplementedError
      end

    end
  end
end