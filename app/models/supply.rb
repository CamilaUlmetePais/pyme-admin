# A good or service purchased by the user, either for sale or internal use.  
#
# @modelAttribute name [String] the name of the good, service, or expense.
# @modelAttribute price [Float] the price the user pays for the supply. 
# @modelAttribute unit [Enum] whether the supply is sold by its weight or in discrete units.	
# @modelAttribute stock [Float] how much of the supply the user currently has in stock. 
# @association has_many [OutflowItems] every time the supply was purchased by the user and how much was purchased.
# @association has_many [Outflows - through OutflowItems] the instances of Outflow in which the supply was purchased
# @association has_many [Suppliers - through Outflows] every Supplier that has sold this supply to the user
# @association alias_attribute [Items] it allows OutflowItems to be referred to as simply <tt>Items</tt> for simplicity.
# @validation name must be present and unique, regardless of capitalization. 
# @validation price must be present and a number greater than 0.
# @validation unit must be present
# @validation stock must be present and a number greater than 0.
# @enum	unit Options: <tt>0 => "kg", 1 => "u", 2 => "ars"</tt> (kilograms, discrete units and money, respectively).
class Supply < ApplicationRecord
	has_many        :outflow_items
	has_many        :outflows, through: :outflow_items
	has_many        :suppliers, through: :outflows
	alias_attribute :items, :outflow_items
	validates       :name, :price, :unit, :stock, presence: true
	validates 			:stock, numericality: { greater_than: 0 }
	validates       :price, numericality: { greater_than: 0 }
	validates       :name, uniqueness: { case_sensitive: false }

	enum unit: [:kg, :u, :ars]

  # Calculates the total sum the user has paid for all their purchases of a supply historically.
	# 
	# @return [Float] How much the user has expended on this supply overall.
	# @example 
	# 	@supply = {id: 1, name: "Biscuits", price: 2.50, stock: 35, unit: "u"}
	# 	@units_bought = 30	
	#
	#		cost_of_biscuits = @supply.cost_of_goods_sold
	#		cost_of_biscuits = 75
	def cost_of_goods_sold
		self.units_bought * self.price
	end

	# Maps the associated suppliers to see the money expended on a service organized by supplier.  
	# 
	# @todo refactor along with supply!
	# @return [Array] An array of hashes with the format Supply [{keys: supplier_id, value: quantity}]
	def get_operative_expenses
		self.suppliers.uniq.map{|supplier| supplier.get_expenses(self.id, self.name)}
	end

	# Mass updates stock 
	# 
	# @todo refactor and document when adding feature. 
	def mass_stock_update(quantity)
		value = self.stock - quantity
		self.update(stock: value)
	end

	# Calculates the total amount of this supply bought by the user historically.
	# 
	# @return [Float] The total amount of this supply bought by the user historically.
	# @example
	# 	@supply = {id: 1, name: "Biscuits", price: 2.50, stock: 35, unit: "u"}
	# 	@outflow_items = [{supply_id: 1, quantity: 10}, {supply_id: 1, quantity: 5}, {supply_id: 1, quantity: 15}]
	# 	
	#		all_biscuits_bought = @supply.units_bought
	#		all_biscuits_bought = 30
	def units_bought
		self.outflow_items.sum('quantity')
	end

	# Updates stock after an outflow is created or updated. 
	# 
	# @!method update_stock(quantity)
	# @param quantity [Float] the amount of supply purchased
	# @return [Object] a supply with updated stock. 
	# @example Add stock to supplies after a purchase. 
	# 	if @outflow.save
	# 		@outflow.each do |item|
	# 			item.supply.update_stock(item.quantity)
	#			end
	def update_stock(quantity)
		value = self.stock + quantity
		self.update(stock: value)
	end
end