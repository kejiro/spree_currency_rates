require 'money'

module Spree
  module CurrencyRates
    class Engine < Rails::Engine
      Environment = Struct.new(:preferences, :sources)


      require 'spree/core'
      #isolate_namespace Spree
      engine_name 'spree_currency_rates'

      initializer 'spree.currency_rates.environment', before: :load_config_initializers do |app|
        app.config.spree_currency_rates = Environment.new(Spree::CurrencyRates::Configuration.new, [])
        Spree::CurrencyRates::Config = app.config.spree_currency_rates.preferences
      end

      initializer 'spree.currency_rates.register.sources', before: :load_config_initializers do |app|
        app.config.spree_currency_rates.sources = [
            Spree::CurrencyRates::Source::Ecb,
            Spree::CurrencyRates::Source::Fixer
        ]
      end

      initializer 'spree_currency_rates.register.bank' do |app|
        ::Money.default_bank = Spree::CurrencyRates::Config.bank
      end

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare(&method(:activate).to_proc)
    end
  end
end