# Methods for the Pages Controller, to help gather and organize the relevant data. 
# 
# @todo review and refactor with supply.  
module PagesHelper
  def consumable_total(supplies)
    supplies.price * supplies.units_bought
  end
  
  # Calculates the percentage of a number based on its total.
  # 
  # @!method percent_of(number, total)
  # @param number [Float] the number to be converted to percentage
  # @param total [Float] the total value as a second data point for the conversion
  # @returns [Float] the percentage value that <tt>number</tt> represents within <tt>total</tt>. 
  # @example Calculate a percentage
  #   percent_of(30, 100) # = 30
  #   percent_of(150.5, 400) # = 37.625
  #   percent_of(1550.60, 5400) # = 28.714814815
  def percent_of(number, total)
    number.to_f / total.to_f * 100.0
  end
  
  def total_cogs(supplies)
    supplies.map{|consumable| consumable.cost_of_goods_sold}.sum
  end
  
  def total_operative_expenses(supplies)
    supplies.map{|operative_expenses| operative_expenses.units_bought}.sum
  end
end