# In a discrete supply purchase (Outflow), every amount of a specific supply the user purchases is an Item of that Outflow — an Outflow Item. They're referred to as simply <tt>Items</tt> for simplicity.
# 
# @modelAttribute quantity [Float] the amount of one discrete supply purchased by the user.
# @association belongs_to [Outflow] the client purchase (Outflow) that contains this item. Every Outflow contains one or more Items. This association is optional because when the Item is created, the Outflow it will be associated to does not yet exist.
# @association belongs_to [Supply] the Supply purchased by the user in the quantity registered in this Item.
# @validation quantity must be present and greater than 0.
# @validation supply_id must be present. 
# @todo refactor stock methods to mirror the structure in Inflow (both methods in Inflow.rb)
class OutflowItem < ApplicationRecord
  belongs_to :outflow, optional: true
  belongs_to :supply
  validates  :quantity, :supply_id, presence: true
  validates  :quantity, numericality: { greater_than: 0 }

  # <b>REFACTOR --</b> Adds stock to supplies and corresponding linked products.
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

  # Formats a string to show on the Outflow#index table by concatenating useful information (the item's quantity, and through association, the supply's name and unit), which makes it more understandable for the user.
	# 
	# @return [String] The Item will be displayed in the following format: <tt>"(supply_name): (quantity) (unit)"</tt>. 
	# @example Get an item's information formatted as a string	
	# 	supply = [id: 1; name: "Beef", unit: "kg"]
	# 	item = [quantity: 2; supply_id: 1]
	# 	
	#		item_information = item.list
	#		item_information = "Beef: 2 kg"
  def list
		self.supply.name + ": " + trim_zeroes(self.quantity).to_s + " " + self.supply.unit.to_s
  end

  # <b>REFACTOR --</b> On delete or edit, restores supply and corresponding linked product stock to previous value.
  def restore_stock
    link = SupplyProductLink.find_by(supply_id: self.supply.id)
    unless self.quantity.nil?
      if link.nil?
        self.supply.update_stock(- self.quantity)
      else
        Product.find(link.product_id).update_stock(- self.quantity)
      end
    end
  end

  # Calculates the item's subtotal by multiplicating its quantity by the associated supply's price. These subtotals will be added up later to generate the associated Outflow's <tt>total</tt> value. 
	# 
	# @return [Float] The amount of money the user will pay for the amount they bought of this particular supply.
	# @example Get an Item's subtotal
	# 	supply = [id: 1, price: 3]
	# 	item = [quantity: 2; supply_id: 1]
	# 	
	#		item_subtotal = item.subtotal
	#		item_subtotal = 6
  def subtotal
    self.quantity * self.supply.price
  end

end