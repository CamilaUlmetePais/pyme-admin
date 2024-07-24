class CreateOutflowItems < ActiveRecord::Migration[7.1]
  def change
    create_table :outflow_items do |t|
      t.float :quantity
      t.references :outflow, null: false, foreign_key: true
      t.references :supply, null: false, foreign_key: true
      t.timestamps
    end
  end
end
