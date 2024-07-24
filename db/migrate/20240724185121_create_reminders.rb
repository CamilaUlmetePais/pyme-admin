class CreateReminders < ActiveRecord::Migration[7.1]
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :text
      t.boolean :done
      t.datetime :due_date
      t.timestamps
    end
  end
end
