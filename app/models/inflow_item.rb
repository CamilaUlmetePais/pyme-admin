class InflowItem < ApplicationRecord
	belongs_to :inflow, optional: true
	belongs_to :product
	validates  :quantity, :product_id, presence: true
	validates  :quantity, numericality: { greater_than: 0 }

	def list
	# formats a string for the index table
		self.product.name + ": " + trim_zeroes(self.quantity).to_s + " " + self.product.unit.to_s
	end

	#def receipt_list
	# formats a string for the receipt (inflows/show)
	#	self.product.name + ": " + trim_zeroes(self.quantity).to_s + " " + self.product.unit + " x $" + trim_zeroes(self.product.price).to_s + " = " 
	#end

	def show_quantity
	# cleans up trailing zeroes for the receipt (inflows/show)
		trim_zeroes(self.quantity)
	end

	def subtotal
	# calculates the item's subtotal (quantity * price)
		self.quantity * self.product.price
	end

	def to_h
		attributes
	end

end