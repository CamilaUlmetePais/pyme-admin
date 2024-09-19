# Represents a purchase made by a client. 
# 
# @modelAttribute total [Float] the total sum of money the client will pay for all the items purchased.
# @modelAttribute payment_method [Enum] the method used by the client to pay for their purchase. 
# @association has_many [InflowItems] all the individual items the purchase consists of. If the Inflow is deleted, the attached Items should be destroyed with it. 
# @association accepts_nested_attributes_for [InflowItems] since the items will be created from the Inflow form, they must be manipulated from the Inflows controller. 
# @association alias_attribute [Items] it allows InflowItems to be referred to as simply <tt>Items</tt> for simplicity.
# @validation payment_method should be present. 
# @enum payment_method Options: <tt> O => cash || 1 => debit || 2 => credit || 3 => pay_pal </tt> 
# @callback after_save [notification_builder] runs the method after creating or updating an inflow.
# @callback after_save [subtract_stock] runs the method after creating or updating an inflow.
class Inflow < ApplicationRecord
	has_many 											:inflow_items, dependent: :destroy
	accepts_nested_attributes_for :inflow_items, allow_destroy: true, reject_if: :all_blank
	alias_attribute 							:items, :inflow_items
	validates_presence_of					:payment_method

  after_save										:notification_builder, :subtract_stock

	scope :by_payment_method, -> (value) { where('payment_method = ?', value) }

	enum payment_method: [:cash, :debit, :credit, :pay_pal] 

	# Triggers the creation of a stock alert Notification if the conditions are met. 
	# When an Inflow is created or updated, this method iterates through the Items inside that Inflow, and checks each associated Product. 
	# If <tt>product.notification?</tt> returns <tt>true</tt>, a stock alert Notification is created for that Product.  
	#
	# @return [Object] Notification
	# @example checks the products purchased to trigger the creation of the appropriate notifications.  
	# 	if @inflow.save
	# 		@inflow.notification_builder
	def notification_builder
		items.each do |item|
			Notification.stock_alert(item.product) if item.product.notification?
		end
	end

	# After the update or deletion of an Inflow, it triggers the update_stocks() method. 
	# 
	# @return [nil]
	# @example Restoring stock to affected products: 
	# 	if @inflow.destroy
	# 		@inflow.restore_stock 
	def restore_stock
		self.update_stocks(false)
	end

	# After the creation or update of an Inflow, it triggers the update_stocks() method. 
	# 
	# @return [nil]
	# @example Subtracting stock from affected products: 
	# 	if @inflow.save
	# 		@inflow.subtract_stock 
	def subtract_stock
		self.update_stocks(true)
	end

	# When called by the subtract_stock or restore_stock methods, it updates the associated Product's stock attribute accordingly: subtracting stock when a purchase is recorded or the quantity is increased, and adding it back when a purchase is deleted from the record or the quantity decreases. 
	# 
	# @!method update_stocks(subtract)
	# @param subtract [Boolean] Specifies whether the method should subtract or restore stock. 
	# @return [nil]
	# @example Subtracting stock after an Inflow is created: 
	# 	update_stocks(true)
	# @example Restoring stock after an Inflow is deleted: 
	# 	update_stocks(false)
	def update_stocks(subtract)
		self.items.each do |item|
			if subtract && !item.quantity.nil?
				value = -item.quantity
			else
				value = item.quantity
			end
			item.product.update_stock(value)
		end
	end
end