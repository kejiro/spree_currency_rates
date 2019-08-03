class CreateSpreeCurrencyRates < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_currency_rates do |t|
      t.string :base_currency, null: false
      t.string :currency, null: false
      t.decimal :rate, precision: 36, scale: 6
      t.references :source
      t.timestamps
      t.timestamp :valid_until
    end
  end
end
