# In a discrete client purchase (Inflow), every amount of a specific product the client purchases is an Item of that Inflow — an Inflow Item. They're referred to as simply <tt>Items</tt> for simplicity.
# 
# @modelAttribute quantity [Float] The amount of one discrete product purchased by the client.
# @association belongs_to [Inflow] the client purchase (Inflow) that contains this item. Every Inflow contains one or more Items. This association is optional because when the Item is created, the Inflow it will be associated to does not yet exist. 
# @association belongs_to [Product] the Product purchased by the client in the quantity registered in this Item.
# @validation quantity must be present and greater than 0.
# @validation product_id must be present. 
class InflowItem < ApplicationRecord
	belongs_to :inflow, optional: true
	belongs_to :product
	validates  :quantity, :product_id, presence: true
	validates  :quantity, numericality: { greater_than: 0 }

	
	# Formats a string to show on the Inflow#index table by concatenating useful information (the item's quantity, and through association, the product's name and unit), which makes it more understandable for the user.
	# 
	# @return [String] The Item will be displayed in the following format: <tt>"(product_name): (quantity) (unit)"</tt>. 
	# @example Get an item's information formatted as a string	
	# 	product = [id: 1; name: "Beef", unit: "kg"]
	# 	item = [quantity: 2; product_id: 1]
	# 	
	#		item_information = item.list
	#		item_information = "Beef: 2 kg"
	def list
		self.product.name + ": " + trim_zeroes(self.quantity).to_s + " " + self.product.unit.to_s
	end	
	
	# Calculates the item's subtotal by multiplicating its quantity by the associated product's price. These subtotals will be added up later to generate the associated Inflow's <tt>total</tt> value. 
	# 
	# @return [Float] The amount of money the client will pay for the amount they bought of this particular product.
	# @example Get an Item's subtotal
	# 	product = [id: 1, price: 3]
	# 	item = [quantity: 2; product_id: 1]
	# 	
	#		item_subtotal = item.subtotal
	#		item_subtotal = 6
	def subtotal
		self.quantity * self.product.price
	end

end