# == Schema Information
#
# Table name: notification_settings
#
#  id                    :bigint           not null, primary key
#  appointment_cancelled :boolean          default(TRUE)
#  appointment_offered   :boolean          default(TRUE)
#  appointment_scheduled :boolean          default(TRUE)
#  sms                   :integer          default("no_sms")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :uuid
#
class NotificationSetting < ApplicationRecord

  belongs_to :user, class_name: "User", foreign_key: "user_id", inverse_of: :notification_setting

  enum sms: {everything: 0, same_as_email: 1, no_sms: 2}

end
