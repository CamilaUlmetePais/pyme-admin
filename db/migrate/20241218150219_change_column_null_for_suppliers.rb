class ChangeColumnNullForSuppliers < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:suppliers, :account_balance, false)
  end
end
