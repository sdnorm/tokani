# == Schema Information
#
# Table name: pay_bill_rates
#
#  id                       :bigint           not null, primary key
#  after_hours_bill_rate    :decimal(, )
#  after_hours_pay_rate     :decimal(, )
#  bill_rate                :decimal(, )
#  cancel_level_1_bill_rate :decimal(, )
#  cancel_level_1_pay_rate  :decimal(, )
#  cancel_level_2_bill_rate :decimal(, )
#  cancel_level_2_pay_rate  :decimal(, )
#  discount_bill_rate       :decimal(, )
#  discount_pay_rate        :decimal(, )
#  effective_date           :date
#  in_person                :boolean
#  interpreter_types        :jsonb
#  is_active                :boolean          default(TRUE)
#  is_default               :boolean
#  mileage_rate             :decimal(, )
#  name                     :string
#  pay_rate                 :decimal(, )
#  phone                    :boolean
#  rush_bill_rate           :decimal(, )
#  rush_pay_rate            :decimal(, )
#  travel_time_rate         :decimal(, )
#  video                    :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  account_id               :uuid
#
class PayBillRate < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :pay_bill_rates, partial: "pay_bill_rates/index", locals: {pay_bill_rate: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :pay_bill_rates, target: dom_id(self, :index) }

  has_many :pay_bill_rate_languages, dependent: :destroy
  has_many :languages, through: :pay_bill_rate_languages

  has_many :pay_bill_rate_customers, dependent: :destroy
  has_many :accounts, through: :pay_bill_rate_customers, validate: false, class_name: "Account", foreign_key: :account_id

  has_many :pay_bill_rate_sites, dependent: :destroy
  has_many :sites, through: :pay_bill_rate_sites, validate: false

  has_many :pay_bill_rate_departments, dependent: :destroy
  has_many :departments, through: :pay_bill_rate_departments

  has_many :pay_bill_rate_interpreters, dependent: :destroy
  has_many :interpreters, through: :pay_bill_rate_interpreters

  has_many :pay_bill_rate_specialties, dependent: :destroy
  has_many :specialties, through: :pay_bill_rate_specialties

  has_many :pay_bill_rate_interpreter_types, dependent: :destroy

  validates :name, presence: true
  validate :must_select_at_least_one_modality

  scope :active, -> { where(is_active: true) }
  scope :default, -> { where(is_default: true) }
  scope :non_default, -> { where(is_default: false) }

  after_create :associate_interpreter_types
  # validate :check_interpreters_languages

  attr_accessor :interpreter_type_ids

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

  def interpreter_types_list
    return "" if pay_bill_rate_interpreter_types.empty?

    int_type_names = pay_bill_rate_interpreter_types.collect do |pbr_int_type|
      InterpreterDetail.interpreter_types.invert[pbr_int_type.interpreter_type]
    end
    int_type_names.join(", ")
  end

  def show_mileage?
    return true if in_person

    mileage_rate.present? ||
      travel_time_rate.present?
  end

  def site_or_department_selected?
    sites.any? || departments.any?
  end

  private

  def must_select_at_least_one_modality
    return if modality_list.present?

    errors.add(:base, "Must select at least one modality")
    false
  end

  def associate_interpreter_types
    return unless interpreter_type_ids.present?

    interpreter_type_ids.each do |interpreter_type|
      PayBillRateInterpreterType.create!(pay_bill_rate: self, interpreter_type: interpreter_type)
    end
  end

  def check_interpreters_languages
    raise "NOT IMPLEMENTED YET (in new jumpstart version of app)"

    # return true if languages.empty?
    # return true if pay_bill_rate_interpreters.nil? || interpreter_ids.empty?

    # self.interpreter_ids = interpreter_ids.compact_blank
    # return true if interpreter_ids.blank?

    # interpreters = Interpreter.find(interpreter_ids)
    # conflict = false
    # interpreters.each do |int|
    #   interpreter_languages = int.languages

    #   unless interpreter_languages.any? { |lang| languages.include?(lang) }
    #     errors.add(:base, "#{int.view_name} does not interpret for the languages of this PayBill Rate")
    #     conflict = true
    #   end
    # end
    # !conflict
  end
end
