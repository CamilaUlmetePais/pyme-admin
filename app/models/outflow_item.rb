class OutflowItem < ApplicationRecord
  belongs_to :outflow, optional: true
  belongs_to :supply
  validates  :quantity, :supply_id, presence: true
  validates  :quantity, numericality: { greater_than: 0 }

  # Adds stock to supplies and corresponding linked products.
  def add_stock
    link = SupplyProductLink.find_by(supply_id: self.supply.id)
    unless self.quantity.nil?
      if link.nil?
        self.supply.update_stock(self.quantity)
      else
        Product.find(link.product_id).update_stock(self.quantity)
      end
    end
  end

  def list
  # formats a string for the index table
		self.supply.name + ": " + trim_zeroes(self.quantity).to_s + " " + self.supply.unit.to_s
	end

  def receipt_list
  # formats a string for the receipt (outflows/show)
    self.supply.name + ": " + trim_zeroes(self.quantity).to_s + " " + self.supply.unit + " x $" + trim_zeroes(self.supply.price).to_s + " = "
  end

  def restore_stock
  # On delete or edit, restores supply and corresponding linked product stock to previous value.
    link = SupplyProductLink.find_by(supply_id: self.supply.id)
    unless self.quantity.nil?
      if link.nil?
        self.supply.update_stock(- self.quantity)
      else
        Product.find(link.product_id).update_stock(- self.quantity)
      end
    end
  end

  def subtotal
	# calculates the item's subtotal (quantity * price)
    self.quantity * self.supply.price
  end

end