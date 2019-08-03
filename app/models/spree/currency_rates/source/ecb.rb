module Spree
  module CurrencyRates
    class Source::Ecb < Source
      def supported_base_currencies
        ['EUR']
      end


      def import
        base_currency = get_base_currency
        raise UnsupportedCurrencyError unless supported_base_currencies.include? base_currency

        url = URI("https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")
        res = Net::HTTP.get(url)

        xml = Hash.from_xml res
        rates = xml["Envelope"]["Cube"]["Cube"]

        supported_currencies = get_supported_currencies

        currency_rates = rates["Cube"].filter { |rate| supported_currencies.include? rate["currency"] }
                             .map { |currency_rate| {base_currency: base_currency, currency: currency_rate["currency"], rate: BigDecimal(currency_rate["rate"])} }

        Spree::CurrencyRate.create currency_rates
      end
    end
  end
end

