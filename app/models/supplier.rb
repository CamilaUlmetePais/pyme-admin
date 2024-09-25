# Represents a person or business that sells supplies or provides services to the user's business. 
# 
# @modelAttribute name [string] the person's or business' name.
# @modelAttribute phone_number [string] the supplier's contact phone number. It's a string in case there are special characters like prefixes like  <tt>+54 (11)</tt>.
# @modelAttribute email [string] the supplier's email.
# @modelAttribute notes [text] a simple field for the user to write down whatever they might wish to remember about this supplier. What they sell, their business hours, any other useful information.
# @modelAttribute account_balance [float] where the user stands with the supplier in terms of money owed. If the user owes money to the supplier (for items bought or services rendered that weren't paid in full) this value will be negative. 
# @modelAttribute notification_threshold [integer] an optional value the user can set to get a notification when the account balance falls below it. 
# @association has_many [Outflows] The supplier's interaction with the user is reflected in outflows, since it represents an expense to the user. 
# @association has_many [OutflowItems - through Outflows] The items that were bought from this supplier
# @association has_many [Supplies - through OutflowItems] The supplies which this supplier has sold to the user
# @validation name must be present and unique, regardless of capitalization. 
# @validation account_balance must be present and a number.
# @validation notification_threshold must be a number, if present. 
class Supplier < ApplicationRecord
	has_many  :outflows
	has_many  :outflow_items, through: :outflows
	has_many  :supplies, through: :outflow_items
	validates :name, :account_balance, presence: true
  validates :account_balance, numericality: true
  validates :notification_threshold, numericality: true, allow_blank: true
	validates :name, uniqueness: { case_sensitive: false }

	# Takes a Supplier and returns a hash <tt>{supply_id: id, supplier_id: id, expenses: Float}</tt> for statistical purposes.
	# 
	# @todo possibly refactor along with supply
	def get_expenses(supply_id, supply_name)
		expenses = self.outflow_items.where(supply_id: supply_id)
		{supply_name: supply_name, supplier_name: self.name, expenses: expenses.sum('quantity')}
	end

	# Determines whether a Balance Alert Notification should be created.
	# 
	# @return [Boolean] <tt>true</tt> if a Notification should be created, <tt>false</tt> if it shouldn't.
	# @example Check a recently created outflow to see if a Notification should be created for that supplier.  
	# 		if @outflow.save
	# 			@outflow.supplier.notification?
	# 		end
  def notification?
    self.account_balance <= self.notification_threshold
  end

	# Restores account_balance to its previous value if an outflow is deleted or before it's updated. 
	# 
	# !@method restore_balance(outflow)
	# @param outflow [Object] the outflow that has been deleted or updated.
	# @return [Object] a Supplier with an updated account_balance.
	# @example Restoring a Supplier's account_balance. 
	# 	if @outflow.destroy
	# 		@outflow.supplier.restore_balance(@outflow)
	# 	end
  def restore_balance(outflow)
    new_balance = self.account_balance - (outflow.paid - outflow.total)
    self.update(account_balance: new_balance)
  end

	# Updates account_balance after an outflow is created or updated. 
	# 
	# !@method update_balance(outflow)
	# @param outflow [Object] the outflow that has been created or updated.
	# @return [Object] a Supplier with an updated account_balance.
	# @example Updating a Supplier's account_balance. 
	# 	if @outflow.save
	# 		@outflow.supplier.update_balance(@outflow)
	# 	end
	def update_balance(outflow)
		new_balance = self.account_balance + (outflow.paid - outflow.total)
    self.update(account_balance: new_balance)
	end

end
