# == Schema Information
#
# Table name: customer_categories
#
#  id                 :bigint           not null, primary key
#  appointment_prefix :string
#  display_value      :string
#  is_active          :boolean
#  sort_order         :bigint
#  telephone_prefix   :string
#  video_prefix       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :uuid
#  backport_id        :bigint
#
# Indexes
#
#  index_customer_categories_on_backport_id    (backport_id)
#  index_customer_categories_on_display_value  (display_value)
#
class CustomerCategory < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :customer_categories, partial: "customer_categories/index", locals: {customer_category: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :customer_categories, target: dom_id(self, :index) }

  # has_many :agency_customers
  has_many :customers
  has_many :customer_details
  validates :telephone_prefix, :video_prefix, :appointment_prefix, presence: true
  validates :telephone_prefix, length: {maximum: 10}
  validates :video_prefix, length: {maximum: 10}
  validates :appointment_prefix, length: {maximum: 10}

  scope :active, -> { where(is_active: true) }

  def modality_prefix(modality)
    case modality
    when "phone"
      return telephone_prefix
    when "in_person", "written"
      return appointment_prefix
    when "video"
      return video_prefix
    end

    raise StandardError, "unknown modality"
  end
end
