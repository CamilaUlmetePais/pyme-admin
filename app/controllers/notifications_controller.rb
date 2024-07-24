class NotificationsController < ApplicationController
	before_action :set_notification, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_cashier, only: [:edit, :update, :destroy, :show]

  def destroy
		@notification.destroy
		respond_to do |format|
			format.html { redirect_to notifications_path,
										alert: {
											message: I18n.t('activerecord.controllers.actions.destroyed',
											model_name: I18n.t('activerecord.models.notification.one') )
										}
									}
			format.json { head :no_content }
		end
	end

  private
		def set_notification
			@notification = Notification.find(params[:id])
		end

		def notification_params
			params.require(:notification).permit(:title, :text)
		end

end