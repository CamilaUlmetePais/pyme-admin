# Automatic notifications to alert the user when a product's stock or a supplier's account balance falls below a number specified by the user. 
# 
# @modelAttribute title [string] A summary of the Notification's contents, mentioning the product/supplier in question. 
# @modelAttribute text [text] The details of the situation being brought to the user's notice.
# @todo remove <tt>last_60_days</tt> scope 
class Notification < ApplicationRecord

	scope :last_60_days, -> { where('created_at >= ?', 60.days.ago) }

	# Creates a 'Stock Alert' Notification when a Product's Stock falls below the Notification Threshold set by the user.
	# 
	# @!method self.stock_alert(product)
	# @param product [Object] the Product that is low in stock. 
	# @return [Object] a new Notification.
	# @example Create a low stock notification
	# 	Notification.stock_alert(product)
	def self.stock_alert(product)
		params = {
			title: I18n.t('notification.stock_alert.title', product: product.name),
			text: I18n.t('notification.stock_alert.text', product: product.name, stock: product.stock),
		}
		self.create(params)
	end

	# Creates a 'Balance Alert' Notification when a Supplier's Account Balance falls below the Notification Threshold set by the user.
	# 
	# @!method self.balance_alert(supplier)
	# @param supplier [Object] the Supplier whose Account Balance fell too low.  
	# @return [Object] a new Notification.
	# @example Create a balance alert notification
	# 	Notification.balance_alert(supplier)
	def self.balance_alert(supplier)
		difference = supplier.notification_threshold - supplier.account_balance
		params     = {
			title: I18n.t('notification.balance_alert.title', supplier: supplier.name.capitalize),
			text: I18n.t('notification.balance_alert.text',
				supplier: supplier.name,
				balance: supplier.account_balance,
				difference: difference
				)
		}
		self.create(params)
	end
end

