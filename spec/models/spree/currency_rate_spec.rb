require 'spec_helper'

RSpec.describe Spree::CurrencyRate, type: :model do
  describe "validating" do
    let(:subject) {Spree::CurrencyRate.new}
    it {should validate_presence_of(:base_currency)}
    it {should validate_presence_of(:currency)}
    it {should validate_presence_of(:rate)}
    it {should validate_numericality_of(:rate).is_greater_than(0.0)}
  end

  it "should invalidate a previous rate when saving" do
    previous = create(:currency_rate)

    current = Spree::CurrencyRate.new(base_currency: previous.base_currency, currency: previous.currency)
    current.rate = BigDecimal("0.5")

    expect(current.save).to be_truthy

    previous.reload
    expect(previous.valid_until).not_to be_nil
  end
end
