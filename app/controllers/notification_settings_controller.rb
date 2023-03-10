class NotificationSettingsController < ApplicationController
  include CurrentHelper
  before_action :authenticate_user!
  before_action :set_notification_setting, only: [:update]

  def create
    @notification_setting = NotificationSetting.new(notification_setting_params)
    @notification_setting.user_id = current_user.id

    respond_to do |format|
      if @notification_setting.save
        format.html { redirect_to after_save_url, notice: "Notification settings saved." }
        format.json { render :show, status: :created, location: @notification_setting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @notification_setting.update(notification_setting_params)
        format.html { redirect_to after_save_url, notice: "Notification settings saved." }
        format.json { render :show, status: :ok, location: @notification_setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def after_save_url
    if current_account_user.interpreter?
      return edit_interpreter_detail_path(current_user&.interpreter_detail)
    else
      return '/'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_notification_setting
    @notification_setting = current_user&.notification_setting
    if @notification_setting.nil?
      return redirect_to interpreter_details_path
    end
  end

  # Only allow a list of trusted parameters through.
  def notification_setting_params
    params.require(:notification_setting).permit(:sms, :appointment_offered, :appointment_scheduled, :appointment_cancelled)
  end
end
