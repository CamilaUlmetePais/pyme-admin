class AddDefaultAccountBalanceToSuppliers < ActiveRecord::Migration[7.1]
  def change
    change_column_default(:suppliers, :account_balance, 0)
  end
end
