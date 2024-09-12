class RemindersController < ApplicationController
	before_action :set_reminder, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_cashier, only: [:edit, :update, :destroy, :show]

	def create
		@reminder = Reminder.new(reminder_params)
		respond_to do |format|
			if @reminder.save
				format.html { redirect_to reminders_path,
											notice: {
												message: I18n.t('activerecord.controllers.actions.created',
												model_name: I18n.t('activerecord.models.reminder.one') )
											}
										}
			else
				format.html { render :new }
				format.json { render json: @reminder.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@reminder.destroy
		respond_to do |format|
			format.html { redirect_to reminders_path,
										alert: {
											message: I18n.t('activerecord.controllers.actions.destroyed',
											model_name: I18n.t('activerecord.models.reminder.one') )
										}
									}
			format.json { head :no_content }
		end
	end

	def edit
	end

	def index
  	@notifications = Notification.last_60_days.order(created_at: :desc).page(params[:page])
  	@reminders = Reminder.last_60_days.order(created_at: :desc).page(params[:page])
	end

	def new
		@reminder = Reminder.new
	end

	def show
	end

	def update
		respond_to do |format|
			if @reminder.update(reminder_params)
				format.html { redirect_to reminders_path,
											notice: {
												message: I18n.t('activerecord.controllers.actions.updated',
												model_name: I18n.t('activerecord.models.reminder.one') )
											}
										}
				format.json { render :show, status: :ok, location: @reminder }
			else
				format.html { render :edit }
				format.json { render json: @reminder.errors, status: :unprocessable_entity }
			end
		end
	end

	private
		def set_reminder
			@reminder = Reminder.find(params[:id])
		end

		def reminder_params
			params.require(:reminder).permit(:title, :text, :done, :due_date)
		end

end