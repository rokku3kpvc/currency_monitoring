class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.column :rate, :decimal, precision: 8, scale: 4, null: false
      t.boolean :is_forced, default: false, null: false
      t.datetime :is_forced_by
      t.timestamps
    end
  end
end
