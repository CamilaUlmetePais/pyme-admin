class CreateSuppliers < ActiveRecord::Migration[7.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :phone_number
      t.float :account_balance
      t.integer :notification_threshold
      t.timestamps
    end
  end
end
