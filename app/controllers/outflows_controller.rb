class OutflowsController < ApplicationController
  before_action :set_outflow, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_manager, only: [:index, :new, :create, :show]
  before_action :authenticate_supervisor, only: [:edit, :update, :destroy]

  # POST /outflows
  # POST /outflows.json
  def create
    @outflow = Outflow.new(outflow_params)
    @outflow.total = generate_outflow_total(outflow_params)
    respond_to do |format|
      if @outflow.save
        @outflow.supplier.update_balance(@outflow)
        @outflow.add_stock
        @outflow.notification_builder
        format.html { redirect_to outflows_path,
                      notice: {
                        message: I18n.t('activerecord.controllers.actions.created',
                        model_name: I18n.t('activerecord.models.outflow.one') )
                      }
                    }
        format.json { render :show, status: :created, location: @outflow }
      else
        @supplies = Supply.all.order(:name)
        format.html { redirect_to outflows_path,
                      alert: {
                        message: I18n.t('activerecord.controllers.actions.failed',
                        model_name: I18n.t('activerecord.models.outflow.one') )
                      }
                    }
      end
    end
  end

  # DELETE /outflows/1
  # DELETE /outflows/1.json
  def destroy
    @outflow.restore_stock
    @outflow.supplier.restore_balance(@outflow)
    @outflow.destroy
    respond_to do |format|
      format.html { redirect_to outflows_path,
                    alert: {
                      message: I18n.t('activerecord.controllers.actions.destroyed',
                      model_name: I18n.t('activerecord.models.outflow.one') )
                    }
                  }
      format.json { head :no_content }
    end
  end

  # GET /outflows/1/edit
  def edit
    @supplies = Supply.all.order(:name)
    @suppliers = Supplier.all.order(:name)
  end

  # GET /outflows
  # GET /outflows.json
  def index
    @outflows = Outflow.all.order(created_at: :desc).page(params[:page])
    @outflows.order(created_at: :desc).page(params[:page])
  end

  # GET /outflows/new
  def new
    @outflow = Outflow.new
    @outflow.items.build
    @supplies = Supply.all.order(:name)
    @suppliers = Supplier.all.order(:name)
  end

  def show
  end

  # PATCH/PUT /outflows/1
  # PATCH/PUT /outflows/1.json
  def update
    respond_to do |format|
      successful = false

      @outflow.transaction do
        @outflow.restore_stock
        @outflow.supplier.restore_balance(@outflow)
        successful = @outflow.update(outflow_params)
        @outflow.add_stock
        @outflow.supplier.update_balance(@outflow)
        @outflow.notification_builder
      end

      if successful
        format.html { redirect_to outflows_path,
                      notice: {
                        message: I18n.t('activerecord.controllers.actions.updated',
                        model_name: I18n.t('activerecord.models.outflow.one') )
                      }
                    }
        format.json { render :show, status: :ok, location: @outflow }
      else
        format.html { render :edit, status: :unprocessable_entity  }
        format.json { render json: @outflow.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def generate_outflow_total(params)
      total = 0
      params[:outflow_items_attributes].to_h.values.each do |item|
        unless item.values.any? {|value| value.empty?}
          supply = Supply.find(item[:supply_id])
          total += item[:quantity].to_f * supply.price
        end
      end
      total
    end

    def outflow_params
      params.require(:outflow).permit(
        :total, :paid, :payment_method, :notes, :supplier_id, :_destroy, :id,
        outflow_items_attributes: [:quantity, :supply_id, :_destroy, :id]
      )
    end

    def set_outflow
      @outflow = Outflow.find(params[:id])
    end
end
