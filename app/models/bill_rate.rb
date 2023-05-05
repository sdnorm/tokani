# == Schema Information
#
# Table name: bill_rates
#
#  id                          :bigint           not null, primary key
#  after_hours_overage         :decimal(8, 2)
#  cancel_rate                 :decimal(8, 2)
#  cancel_rate_trigger         :integer
#  default_rate                :boolean          default(FALSE)
#  hourly_bill_rate            :decimal(8, 2)
#  in_person                   :boolean          default(FALSE)
#  is_active                   :boolean          default(TRUE)
#  minimum_time_charged        :integer
#  name                        :string
#  phone                       :boolean          default(FALSE)
#  regular_hours_end_seconds   :integer
#  regular_hours_start_seconds :integer
#  round_increment             :integer
#  round_time                  :integer
#  rush_overage                :decimal(8, 2)
#  rush_overage_trigger        :integer
#  video                       :boolean          default(FALSE)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  account_id                  :uuid
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
  # has_many :accounts, through: :bill_rate_customers, validate: false, class_name: "Account", foreign_key: :account_id
  has_many :accounts, through: :bill_rate_customers, validate: false, class_name: "Account", foreign_key: :account_id

  scope :active, -> { where(is_active: true) }

  has_many :customers, through: :bill_rate_customers, class_name: "Account", foreign_key: :account_id
  enum round_time: {round_closest: 1, round_down: 2, round_up: 3}

  validate :check_default_or_language_rate
  validates :name, presence: true
  validate :must_select_at_least_one_modality

  def start_hour(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).hour
      end
    else
      self[column] / 3600
    end
  end

  def start_minute(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).min
      end
    else
      ((self[column] / 3600.0).modulo(1) * 60).to_i
    end
  end

  def end_hour(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).hour
      end
    else
      self[column] / 3600
    end
  end

  def end_minute(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).min
      end
    else
      ((self[column] / 3600.0).modulo(1) * 60).to_i
    end
  end

  def make_regularhours_times_from_hash(thash)
    start_times = thash.try(:fetch, :regular_hours_start_seconds)
    end_times = thash.try(:fetch, :regular_hours_end_seconds)

    return false if start_times.blank? || end_times.blank?

    return false if start_times[:hour].blank? || end_times[:hour].blank?

    begin
      start_hour = Integer(start_times[:hour].sub(/^0/, ""))

      end_hour = Integer(end_times[:hour].sub(/^0/, ""))

      self.regular_hours_start_seconds = (start_hour * 3600)
      self.regular_hours_end_seconds = (end_hour * 3600)
    rescue => e
      logger.warn "Error: #{e}"
      false
    end
  end

  def modality_list
    list = []
    list << "In Person" if in_person
    list << "Phone" if phone
    list << "Video" if video
    list.join(", ")
  end

  def language_list
    languages.map(&:name).sort.join(", ")
  end

  def customer_list
    customers.map(&:name).sort.join(", ")
  end

  def check_default_or_language_rate
    if language_ids.present? && !default_rate == false
      errors.add(:base, "Cannot have default and language specific rate")
      return false
    end
    true
  end

  def is_default?
    default_rate
  end

  def must_select_at_least_one_modality
    return if modality_list.present?

    errors.add(:base, "Must select at least one modality")
    false
  end
end
