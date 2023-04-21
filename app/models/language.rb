# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  is_active  :boolean          default(TRUE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid             not null
#
# Indexes
#
#  index_languages_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Language < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :languages, partial: "languages/index", locals: {language: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :languages, target: dom_id(self, :index) }

  # has_many :appointment_languages, dependent: :destroy
  has_many :interpreter_languages, dependent: :destroy
  belongs_to :account

  has_many :bill_rate_languages, dependent: :destroy
  has_many :bill_rates, through: :bill_rate_languages

  has_many :pay_rate_languages, dependent: :destroy
  has_many :pay_rates, through: :pay_rate_languages

  validates :name, presence: true

  attribute :is_active, :boolean, default: true

  def toggle_active!
    update! is_active: !is_active
  end
end
