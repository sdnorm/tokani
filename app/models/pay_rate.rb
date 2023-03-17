# == Schema Information
#
# Table name: pay_rates
#
#  id                   :bigint           not null, primary key
#  after_hours_overage  :decimal(8, 2)
#  cancel_rate          :decimal(8, 2)
#  default_rate         :boolean          default(FALSE)
#  hourly_pay_rate      :decimal(8, 2)
#  in_person            :boolean          default(FALSE)
#  is_active            :boolean          default(TRUE)
#  minimum_time_charged :integer
#  name                 :string
#  phone                :boolean          default(FALSE)
#  rush_overage         :decimal(8, 2)
#  video                :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :uuid
#
class PayRate < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :pay_rates, partial: "pay_rates/index", locals: {pay_rate: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :pay_rates, target: dom_id(self, :index) }

  belongs_to :account

  has_many :pay_rate_languages, dependent: :destroy
  has_many :languages, through: :pay_rate_languages

  has_many :pay_rate_interpreters, dependent: :destroy
  has_many :interpreters, through: :pay_rate_interpreters, validate: false, class_name: "User", foreign_key: :interpreter_id

  scope :active, -> { where(is_active: true) }
end
