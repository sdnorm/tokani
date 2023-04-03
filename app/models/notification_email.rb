# == Schema Information
#
# Table name: notification_emails
#
#  id                    :bigint           not null, primary key
#  appointment_cancelled :boolean          default(TRUE)
#  appointment_created   :boolean          default(TRUE)
#  appointment_declined  :boolean          default(TRUE)
#  appointment_edited    :boolean          default(TRUE)
#  email1                :string
#  email2                :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  account_id            :uuid
#
class NotificationEmail < ApplicationRecord
  belongs_to :account
end
