class Product < ApplicationRecord
	has_many        :inflow_items
	alias_attribute :items, :inflow_items
	validates       :name, :price, :unit, presence: true
	validates				:notification_threshold, numericality: true, allow_blank: true
	validates       :stock, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
	validates       :price, numericality: { greater_than: 0 }
	validates       :name, uniqueness: { case_sensitive: false }

	enum unit: [:kg, :u]

	def notification?
		self.stock <= self.notification_threshold
	end

	def units_sold
		self.inflow_items.sum('quantity')
	end

	def update_stock(quantity)
		value = self.stock + quantity
		self.update(stock: value)
	end

	def sales_total
		self.units_sold * self.price
	end
end
