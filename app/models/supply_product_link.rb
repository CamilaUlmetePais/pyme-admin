# The products that are sold without being modified in any way can be connected so that the product's stock is updated automatically when the supply is bought, without the user having to update it by hand. 
# 
# @modelAttribute product_id [Integer] The ID of the product that will be sold without modification.
# @modelAttribute supply_id [Integer] The ID of the supply that will be connected to the product. 
# @validation product_id must be present and unique.
# @validation supply_id must be present and unique.
class SupplyProductLink < ApplicationRecord
	validates :product_id, :supply_id, presence: true
	validates :product_id, :supply_id, uniqueness: true
end