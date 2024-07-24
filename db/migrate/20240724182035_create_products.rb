class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :unit
      t.float :stock
      t.integer :notification_threshold
      t.timestamps
    end
  end
end
