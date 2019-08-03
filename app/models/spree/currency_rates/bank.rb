require 'money'

class Spree::CurrencyRates::Bank < Money::Bank::Base
  def exchange_with(from, to_currency, &block)
    to_currency = Money::Currency.wrap(to_currency)
    if from.currency == to_currency
      from
    else
      if (rate = get_rate(from.currency, to_currency))
        fractional = calculate_fractional(from, to_currency)
        from.class.new(exchange(fractional, rate, &block), to_currency)
      else
        raise Money::Bank::UnknownRate, "No conversion rate known for '#{from.currency.iso_code}' -> '#{to_currency}'"
      end
    end
  end

  def get_rate(from, to, opts = {})
    rate = Spree::CurrencyRate.find_by_base_currency_and_currency(Money::Currency.wrap(from).iso_code, Money::Currency.wrap(to).iso_code)
    return false if rate.nil?

    rate.rate
  end

  protected

  def calculate_fractional(from, to_currency)
    BigDecimal(from.fractional.to_s) / (
    BigDecimal(from.currency.subunit_to_unit.to_s) /
        BigDecimal(to_currency.subunit_to_unit.to_s)
    )
  end

  def exchange(fractional, rate, &block)
    ex = fractional * BigDecimal(rate.to_s)
    if block_given?
      yield ex
    elsif @rounding_method
      @rounding_method.call(ex)
    else
      ex
    end
  end
end
