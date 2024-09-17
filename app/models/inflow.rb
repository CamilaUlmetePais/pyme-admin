class Inflow < ApplicationRecord
	has_many 											:inflow_items, dependent: :destroy
	accepts_nested_attributes_for :inflow_items, allow_destroy: true, reject_if: :all_blank
	alias_attribute 							:items, :inflow_items
	validates_presence_of					:payment_method

  after_save										:notification_builder, :subtract_stock

	scope :by_payment_method, -> (value) { where('payment_method = ?', value) }

	enum payment_method: [:cash, :debit, :credit, :pay_pal] 

	def notification_builder
		items.each do |item|
			Notification.stock_alert(item.product) if item.product.notification?
		end
	end

	def restore_stock
		self.update_stocks(false)
	end

	def subtract_stock
		self.update_stocks(true)
	end

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