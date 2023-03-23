class NotificationEmailsController < ApplicationController
  include CurrentHelper
  before_action :authenticate_user!
  before_action :set_notification_email, only: [:update]

  def create
    @notification_email = NotificationEmail.new(notification_email_params)
    @notification_email.account_id = current_account.id

    respond_to do |format|
      if @notification_email.save
        format.html { redirect_to after_save_url, notice: "Notification emails saved." }
        format.json { render :show, status: :created, location: @notification_email }
      else
        format.html { redirect_to after_save_url, alert: "Notification emails could not be saved: #{@notification_email.errors.full_messages.join("; ")}" }
        format.json { render json: @notification_email.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @notification_email.update(notification_email_params)
        format.html { redirect_to after_save_url, notice: "Notification emails saved." }
        format.json { render :show, status: :ok, location: @notification_email }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification_email.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def after_save_url
    notification_settings_path
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_notification_email
    @notification_email = current_account&.notification_email
    if @notification_email.nil?
      redirect_to notification_settings_path
    end
  end

  # Only allow a list of trusted parameters through.
  def notification_email_params
    params.require(:notification_email).permit(:email1, :email2, :appointment_created, :appointment_edited, :appointment_declined,
      :appointment_cancelled)
  end
end
