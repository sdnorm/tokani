class ApplicationMailer < ActionMailer::Base
  default from: Jumpstart.config.support_email
  FROM_NAME = "Tokani Notifications"
  layout "mailer"

  # Include any view helpers from your main app to use in mailers here
  helper ApplicationHelper

  def get_email_vars(recipient, params)
    tz = Account.time_zone_default
    if recipient.present?
      to_email = email_address_with_name(recipient.email, recipient.full_name)
      tz = recipient.time_zone || Account.time_zone_default
    else
      to_email = params[:email]
      tz = params[:account]&.agency_detail&.time_zones&.first || Account.time_zone_default
    end

    [to_email, tz]
  end
end
