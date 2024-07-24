class CreateInflowItems < ActiveRecord::Migration[7.1]
  def change
    create_table :inflow_items do |t|
      t.float :quantity
      t.references :inflow, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
