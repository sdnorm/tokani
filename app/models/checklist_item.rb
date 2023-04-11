# == Schema Information
#
# Table name: checklist_items
#
#  id                :bigint           not null, primary key
#  bool_val          :boolean
#  exp_date          :date
#  start_date        :date
#  text_val          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  checklist_type_id :bigint           not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_checklist_items_on_checklist_type_id  (checklist_type_id)
#  index_checklist_items_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (checklist_type_id => checklist_types.id)
#  fk_rails_...  (user_id => users.id)
#
class ChecklistItem < ApplicationRecord
  #  belongs_to :interpreter, foreign_key: 'user_id'
  belongs_to :user
  belongs_to :checklist_type

  has_one_attached :document

  default_scope { includes(:checklist_type) }

  validate :uniq_checklist_types, if: -> { user.present? }
  validate :exp_date_required, if: -> { checklist_type.present? }
  validate :upload_required, if: -> { checklist_type.present? }

  def uniq_checklist_types
    my_brothers = user.checklist_items
    return true if my_brothers.blank?

    my_brothers.each do |bro|
      if bro.checklist_type == checklist_type && bro.id != id
        errors.add(:base, "This checklist type is already assigned")
        return false
      end
    end
    true
  end

  def exp_date_required
    if checklist_type.requires_expiration? && exp_date.blank?
      errors.add(:exp_date, "Is required")
      return false
    end
    true
  end

  def upload_required
    if checklist_type.requires_upload? && document.attached? == false
      errors.add(:base, "Upload is required")
      return false
    end
    true
  end

  def name
    checklist_type.name
  end

  # def interpreter_id=(int_id)
  #   self.user_id = int_id
  # end

  # def interpreter_id
  #   self.user_id
  # end
end
