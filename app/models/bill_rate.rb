# == Schema Information
#
# Table name: bill_rates
#
#  id                        :bigint           not null, primary key
#  after_hours_end_seconds   :integer
#  after_hours_overage       :decimal(8, 2)
#  after_hours_start_seconds :integer
#  cancel_rate               :decimal(8, 2)
#  cancel_rate_trigger       :integer
#  default_rate              :boolean          default(FALSE)
#  hourly_bill_rate          :decimal(8, 2)
#  in_person                 :boolean          default(FALSE)
#  is_active                 :boolean          default(TRUE)
#  minimum_time_charged      :integer
#  name                      :string
#  phone                     :boolean          default(FALSE)
#  round_increment           :integer
#  round_time                :integer
#  rush_overage              :decimal(8, 2)
#  rush_overage_trigger      :integer
#  video                     :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  account_id                :uuid
#
class BillRate < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :bill_rates, partial: "bill_rates/index", locals: {bill_rate: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :bill_rates, target: dom_id(self, :index) }

  belongs_to :account

  has_many :bill_rate_languages, dependent: :destroy
  has_many :languages, through: :bill_rate_languages

  has_many :bill_rate_customers, dependent: :destroy
  has_many :accounts, through: :bill_rate_customers, validate: false, class_name: "Account", foreign_key: :account_id

  scope :active, -> { where(is_active: true) }
end
