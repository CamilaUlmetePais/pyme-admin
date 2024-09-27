# Represents a product for sale. 
# 
# @modelAttribute name [String] the name of the product 
# @modelAttribute price [Float] the current price the client will pay when purchasing the product
# @modelAttribute unit [Enum] what unit the product is sold in, if by weight or in a discrete, unitary packaging
# @modelAttribute stock [Float] how much of the product is currently available for sale
# @modelAttribute notification_threshold [Float] an optional value the user can set to receive an automatic notification. If the product's stock falls below this value, a Low-Stock Notification will be created and shown to the user. 
# @association has_many [InflowItems] Each time the product has been sold to a client. 
# @association alias_attribute [Items] it allows InflowItems to be referred to as simply <tt>Items</tt> for simplicity.
# @validation name should be present and unique, regardless of capitalization.
# @validation price should be present and a number greater than 0.
# @validation unit should be present.
# @validation stock should be a number equal to or greater than 0, if present. 
# @validation notification_threshold should be a number, if present.
# @enum Unit Options: <tt>0 => "kg", 1 => "u"</tt> (kilograms and units, respectively).
class Product < ApplicationRecord
	has_many        :inflow_items
	alias_attribute :items, :inflow_items
	validates       :name, :price, :unit, presence: true
	validates				:notification_threshold, numericality: true, allow_blank: true
	validates       :stock, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
	validates       :price, numericality: { greater_than: 0 }
	validates       :name, uniqueness: { case_sensitive: false }

	enum unit: [:kg, :u]

	# Determines whether a Low Stock Notification should be created.
	# 
	# @return [Boolean] <tt>true</tt> if a Notification should be created, <tt>false</tt> if it shouldn't.
	# @example Check a recently created inflow to see if a Notification should be created for any of the products just sold.  
	# 		@inflow.items.each do |item|
	# 			item.product.notification?
	# 		end
	def notification?
		self.stock <= self.notification_threshold
	end

	# Adds up all the sales for a product for statistical purposes.  
	#
	# @return [Float] the total quantity sold of a product.
	# @example Get the total amount sold of a product.
	# 	@product = {id: 1, name: "Biscuits", price: 2.50, unit: u, stock: 10}
	#		all_inflow_items = [{product_id: 1, quantity: 4}, {product_id: 1, quantity: 5}, {product_id: 1, quantity: 8}]
	#		
	#		units_sold = @product.units_sold
	# 	units_sold = 17
	def units_sold
		self.inflow_items.sum('quantity')
	end

	# Updates a product's stock according to a given amount after more product is produced.
	#
	# @return [Object] an instance of Product with updated stock
	# @example Add product when a new batch of it is produced.
	# 	product = {name: "Biscuits", price: 2.50, unit: u, stock: 10}
	# 	new_batch = 25   # user input
	#
	# 	product.update_stock(new_batch)
	# 	product.stock = 35
	# @todo Add mass stock update feature - that is why this method exists. 
	def update_stock(quantity)
		value = self.stock + quantity
		self.update(stock: value)
	end

	# Calculates the total sum of money made from the sales of a product for statistical purposes, multiplying the amount of units sold by the product's price. 
	# 
	# @return [Float] the amount of money the business has made from a product's sales.
	# @example Get the amount of money made by selling a product
	#		@product = {id: 1, name: "Biscuits", price: 2.50, unit: u, stock: 10}
	#		@product.units_sold = 17
	#		
	#		sales_total = @product.sales_total
	#		sales_total = 42.5
	def sales_total
		self.units_sold * self.price
	end
end
