class AddDetailsToSuppliers < ActiveRecord::Migration[7.1]
  def change
    add_column :suppliers, :email, :string
    add_column :suppliers, :notes, :text
  end
end
