class NotificationSettingsController < ApplicationController
  include CurrentHelper
  before_action :authenticate_user!
  before_action :set_notification_setting, only: [:update]

  def index
    @notification_setting = current_user.notification_setting || NotificationSetting.new
    if @notification_setting.new_record?
      @url = notification_settings_path
      @method_name = :post
    else
      @url = notification_setting_path(@notification_setting)
      @method_name = :put
    end

    @notification_email = current_account.notification_email || NotificationEmail.new
    if @notification_email.new_record?
      @email_url = notification_emails_path
      @email_method_name = :post
    else
      @email_url = notification_email_path(@notification_email)
      @email_method_name = :put
    end
  end

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
      edit_interpreter_detail_path(current_user&.interpreter_detail)
    else
      notification_settings_path
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_notification_setting
    @notification_setting = current_user&.notification_setting
    if @notification_setting.nil?
      redirect_to interpreter_details_path
    end
  end

  # Only allow a list of trusted parameters through.
  def notification_setting_params
    params.require(:notification_setting).permit(:sms, :sms_number, :appointment_offered, :appointment_scheduled, :appointment_cancelled,
      :appointment_created, :appointment_declined, :appointment_reminder, :appointment_covered, :checklist_item_expiration)
  end
end
