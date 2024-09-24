# Represents an expense made by the user, such as a supply purchase or the payment of taxes and employee salaries. 
# 
# @modelAttribute total [Float] the total sum of money owed to the supplier for all the items purchased/services rendered.
# @modelAttribute paid [Float] the amount of money the user paid at the moment of purchase/payment. This is a separate attribute from <tt>Total</tt> because it's quite common in businesses of all sizes, but particularly in small ones, to pay only a part of what's purchased at the moment and be left with a debt. I wanted a way to reflect that in reality, so that the user can have an accurate registry of any debts to suppliers or other entities. 
# @modelAttribute payment_method [Enum] the method used by the user to pay for the purchase/expense.
# @modelAttribute notes [Text] a simple field for the user to record important information about the expense that they want to remember later. 
# @association belongs_to [Supplier] the Supplier that is providing the supplies/services the user is purchasing at this time. 
# @association has_many [OutflowItems] all the individual items the purchase/expense consists of. If the Outflow is deleted, the attached Items should be destroyed with it.
# @association accepts_nested_attributes_for [OutflowItems] since the items will be created from the Outflow form, they must be manipulated from the Outflows controller.
# @association alias_attribute[Items] it allows OutflowItems to be referred to as simply <tt>Items</tt> for simplicity.
# @validation paid should be present and should be a number
# @validation supplier_id should be present
# @validation payment_method should be present
# @callback before_update [generate_total] Adds the total to the Outflow after updating. 
# @scope date_range filters outflows between the two dates provided by the user in the search form to return only the outflows created between those two dates. 
# @enum payment_method Options <tt> O => cash || 1 => debit || 2 => credit || 3 => electronic_wallet</tt>
class Outflow < ApplicationRecord
	before_update 								:generate_total # DUPLICATE
	belongs_to 										:supplier
	has_many 											:outflow_items, dependent: :destroy
	accepts_nested_attributes_for :outflow_items, allow_destroy: true, reject_if: :all_blank
	alias_attribute 							:items, :outflow_items
	validates 										:paid, :supplier_id,:payment_method, presence: true
	validates 										:paid, numericality: true

	before_update 								:generate_total # DUPLICATE
  #after_save										:notification_builder, :add_stock

	scope :date_range, -> (start_date, end_date) { where(
		'created_at >= ? AND created_at <= ?', start_date, end_date) }

	enum payment_method: [:cash, :debit, :credit, :electronic_wallet]

	# Adds stock to a supply when the user purchases more of it. 
	# 
	# @return [Object] a Supply with updated Stock according to the user's purchase. 
	# @example 
	# 	if @outflow.save
	# 		@outflow.add_stock
	def add_stock
		self.items.each do |item|
			item.add_stock
		end
	end

	# Calculates the total by adding the item's subtotals and assigns the value to the <tt>Total</tt> attribute.
	# 
	# @return [Object] an Outflow with the appropriate <tt>Total</tt> value.
	# @example Calculate an Outflow's total
	# 	 @outflow.generate_total
	def generate_total
		self.total = 0
		self.items.each do |item|
			self.total += item.subtotal
		end
	end

	# Triggers the creation of a balance alert Notification if the conditions are met. When an Outflow is created or updated, this method checks the associated Supplier. If <tt>supplier.notification?</tt> returns <tt>true</tt>, a balance alert Notification is created for that Supplier.
	# 
	# @return [Object] Notification
	# @example checks the associated Supplier to trigger the creation of the appropriate notification.  
	# 	if @outflow.save
	# 		@outflow.notification_builder
	def notification_builder
		Notification.balance_alert(supplier) if supplier.notification?
	end

	# Subtracts Stock from a Supply when the user deletes a purchase made. 
	# 
	# @return [Object] a Supply with its Stock restored to its previous value. 
	# @example 
	# 	if @outflow.destroy
	# 		@outflow.restore_stock
	def restore_stock
		self.items.each do |item|
			item.restore_stock
		end
	end

end