class CreateSupplyProductLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :supply_product_links do |t|
      t.references :supply, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
