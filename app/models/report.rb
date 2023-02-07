# == Schema Information
#
# Table name: reports
#
#  id                   :bigint           not null, primary key
#  date_begin           :date
#  date_end             :date
#  fields_to_show       :string
#  in_person            :boolean
#  interpreter_type     :string
#  phone                :boolean
#  report_type          :integer
#  video                :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :uuid
#  customer_category_id :integer
#  department_id        :uuid
#  language_id          :integer
#  site_id              :uuid
#

require "csv"

class Report < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :reports, partial: "reports/index", locals: {report: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :reports, target: dom_id(self, :index) }

  include ActionView::Helpers::NumberHelper
  include ReportsHelper

  serialize :fields_to_show, Array

  has_many :report_customers, dependent: :destroy
  has_many :customers, through: :report_customers, validate: false, class_name: "Account", foreign_key: :account_id

  enum report_type: {financial: 0, fill_rate: 1}

  attr_accessor :show_fields

  def fetch_appointments
    report_service = ReportService.new(self)
    report_service.fetch_appointments
  end

  def modalities
    m = []

    m << "in_person" if in_person
    m << "phone" if phone
    m << "video" if video

    m
  end

  def to_csv
    CSV.generate do |csv|
      csv << csv_headers
      fetch_appointments.each do |appt|
        csv << fields_to_add(appt)
      end
    end
  end

  def csv_headers
    headers = []
    fields_to_show.each do |appt_field|
      headers << reportable_fields[appt_field] if reportable_fields[appt_field]
    end

    headers
  end

  def fields_to_add(appt)
    fields = []
    fields_to_show.each do |appt_field|
      case appt_field
      when "appt-number"
        fields << appt.refnumber
      when "date-of-service"
        fields << appt.start_time.to_date.to_s
      when "time-of-service"
        fields << appt.start_time.strftime("%l:%M %p")
      when "customer-name"
        fields << appt.customer&.name
      when "site"
        fields << appt.site&.name
      when "department"
        fields << appt.department&.name
      when "requestor-name"
        fields << appt.requestor&.full_name
      when "interpreter-name"
        fields << appt.interpreter&.full_name
      when "language"
        fields << appt.language&.name
      when "modality"
        fields << appt.modality&.titleize
      when "duration"
        fields << appt.duration_viewable
      when "datetime-start"
        fields << appt.start_time.strftime("%Y-%m-%d %l:%M %p")
      when "datetime-end"
        fields << appt.finish_time&.strftime("%Y-%m-%d %l:%M %p")
      when "actual-duration"
        fields << "#{appt.calculated_appointment_duration_in_hours} hours"
      when "amount-paid"
        fields << number_to_currency(appt.total_paid)
      when "amount-billed"
        fields << number_to_currency(appt.total_billed)
      when "mileage-paid"
        fields << "TODO"
      when "mileage-billed"
        fields << "TODO"
      when "total-paid"
        fields << "TODO"
      when "total-billed"
        fields << "TODO"
      when "profit-margin"
        fields << "TODO"
      end
    end

    fields
  end
end
