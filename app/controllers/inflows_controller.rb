# @!visibility private
class InflowsController < ApplicationController
  before_action :set_inflow, only: [:show, :edit, :update, :destroy, :add_items, :expand]
  before_action :authenticate_cashier, only: [:edit, :update, :destroy]

  def add_items
    items_to_add = inflow_params[:inflow_items_attributes]#.map {|item| !item[].empty? }
    items_to_add.keys.each do |key|
      ready_item = items_to_add[key].push(inflow_id: @inflow.id)
      @new_item = InflowItem.new(ready_item)
      @new_item.save
    end
    respond_to do |format|
      format.html { redirect_to inflows_path,
                    notice: {
                      message: I18n.t('activerecord.controllers.actions.expanded',
                      model_name: I18n.t('activerecord.models.inflow.one') )
                    }
                  }
      end
  end 

  # POST /inflows
  def create
    @inflow = Inflow.new(inflow_params)
    @inflow.total = generate_inflow_total(inflow_params)
    respond_to do |format|
      if @inflow.save
        @inflow.notification_builder
        format.html { redirect_to inflows_path,
                      notice: {
                        message: I18n.t('activerecord.controllers.actions.created',
                        model_name: I18n.t('activerecord.models.inflow.one') )
                      }
                    }
        format.json { render :show, status: :created, location: @inflow }
      else
        @products = Product.all.order(:name)
        format.html { redirect_to inflows_path,
                      alert: {
                        message: I18n.t('activerecord.controllers.actions.failed',
                        model_name: I18n.t('activerecord.models.inflow.one') )
                      }
                    }
      end
    end
  end

  # DELETE /inflows/1
  def destroy
    @inflow.restore_stock
    @inflow.destroy
    respond_to do |format|
      format.html { redirect_to inflows_path,
                    alert: {
                      message: I18n.t('activerecord.controllers.actions.destroyed',
                      model_name: I18n.t('activerecord.models.inflow.one') )
                    }
                  }
      format.json { head :no_content }
    end
  end


  # @!visibility private
  # GET /inflows/1/edit
  def edit 
    @products = Product.all.order(:name)
  end

  def expand
    @products = Product.all.order(:name)
  end

  # GET /inflows
  def index
    @inflows = Inflow.all.order(created_at: :desc).page(params[:page])
    search_payment_method unless search_params.nil?
    @inflows.order(created_at: :desc).page(params[:page])
  end

  # GET /inflows/new
  def new
    @inflow = Inflow.new
    @inflow.items.build
    @products = Product.all.order(:name)
  end

  # @!visibility private
  def show
  end

  # PATCH/PUT /inflows/1
  def update
    respond_to do |format|
      successful = false
      @inflow.transaction do
        @inflow.restore_stock
        successful = @inflow.update(inflow_params)
      end
      if successful
        @inflow.notification_builder
        format.html { redirect_to inflows_path,
                      notice: {
                        message: I18n.t('activerecord.controllers.actions.updated',
                        model_name: I18n.t('activerecord.models.inflow.one') )
                      }
                    }
        format.json { render :show, status: :ok, location: @inflow }
      else
        format.html { render :edit, status: :unprocessable_entity  }
        format.json { render json: @inflow.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def generate_inflow_total(params)
      total = 0
      params[:inflow_items_attributes].to_h.values.each do |item|
        unless item[:product_id].empty? || item[:quantity].empty?
          product = Product.find(item[:product_id])
          total += item[:quantity].to_f * product.price
        end
      end
      total
    end
 
    def inflow_params
      params.require(:inflow).permit(
        :total, :payment_method, :_destroy, :id,
        inflow_items_attributes: [:id, :quantity, :product_id, :_destroy]
      )
    end

    def search_params
      params.require(:inflow).permit(:payment_method) unless params[:inflow].nil?
    end

    def search_payment_method
      @inflows = @inflows.by_payment_method(search_params[:payment_method]) 
    end

    def set_inflow
      @inflow = Inflow.find(params[:id])
    end
end
