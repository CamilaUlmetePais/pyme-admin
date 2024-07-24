class CreateOutflows < ActiveRecord::Migration[7.1]
  def change
    create_table :outflows do |t|
      t.float :total
      t.integer :payment_method
      t.text :notes
      t.float :paid
      t.references :supplier, null: false, foreign_key: true
      t.timestamps
    end
  end
end
