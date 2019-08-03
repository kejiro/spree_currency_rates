class Spree::CurrencyRate < ApplicationRecord
  validates :base_currency, :currency, :rate, presence: true
  validates :rate, numericality: {greater_than: 0.0}

  before_create :invalidate_old_rate

  private

  def invalidate_old_rate
    q = Spree::CurrencyRate.where(base_currency: base_currency, currency: currency, valid_until: nil)
    q.update_all(valid_until: Time.now)
  end
end
