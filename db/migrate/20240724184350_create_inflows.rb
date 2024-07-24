class CreateInflows < ActiveRecord::Migration[7.1]
  def change
    create_table :inflows do |t|
      t.float :total
      t.integer :payment_method
      t.timestamps
    end
  end
end
