class PagesController < ApplicationController
	before_action :authenticate_cashier, only: [:register]
  before_action :authenticate_owner, only: [:statistics]

	def statistics
    @inflows = Inflow.all
    @outflows = Outflow.all
    statistics_range unless statistics_params.nil?
    inflows_total      = @inflows.sum('total')
    outflows_total     = @outflows.sum('total')
    supplies           = Supply.all
    consumables        = supplies.where.not(unit: "$")
    operative_expenses = supplies - consumables
    op_ex_by_supplier  = operative_expenses.map{|supply| supply.get_operative_expenses}.flatten

    @products   = Product.all
    @suppliers  = Supplier.all
    @statistics = {
      gross_income: inflows_total,
      total_expenses: outflows_total,
      balance: inflows_total - outflows_total,
      consumables: consumables,
      operative_expenses: operative_expenses,
      op_ex_by_supplier: op_ex_by_supplier
      }
  end

	def register
		@inflows   = Inflow.all
		@outflows  = Outflow.all
		register_date unless register_params.nil?
		@variables = {
			inflow_total: @inflows.sum('total'),
			outflow_total: @outflows.sum('total'),
      cash_inflows: @inflows.where(payment_method: 0),
			cash_outflows: @outflows.where(payment_method: 0)
		 }
	end

	private
	def statistics_params
    params.require(:pages).permit(:date_from, :date_to) unless params[:pages].nil?
  end

  def statistics_range
    empty = statistics_params[:date_from].empty? && statistics_params[:date_to].empty?
    unless empty
      start_date = DateTime.strptime(statistics_params[:date_from], '%m/%d/%Y')
      end_date = DateTime.strptime(statistics_params[:date_to], '%m/%d/%Y')
      @inflows = @inflows.date_range(start_date, end_date)
      @outflows = @outflows.date_range(start_date, end_date)
    end
  end

	def register_params
		params.require(:pages).permit(:date) unless params[:pages].nil?
	end

	def register_date
		date = DateTime.strptime(register_params[:date], '%m/%d/%Y')
		@inflows = @inflows.date_range(date, date.end_of_day) unless register_params[:date].empty?
		@outflows = @outflows.date_range(date, date.end_of_day) unless register_params[:date].empty?
	end

end
