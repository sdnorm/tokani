# == Schema Information
#
# Table name: process_batches
#
#  id           :bigint           not null, primary key
#  batch_type   :integer
#  is_processed :boolean          default(FALSE)
#  total        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :uuid
#  process_id   :integer
#
require "csv"

class ProcessBatch < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :account
  has_many :process_batch_appointments, dependent: :destroy
  has_many :appointments, through: :process_batch_appointments

  enum batch_type: {customer: 0, interpreter: 1}

  after_create :set_process_batch_id
  after_create :associate_appointments

  scope :latest, -> { order(created_at: :desc) }

  attr_accessor :start_date, :end_date, :customer_ids, :interpreter_ids

  # Groups appointments into Customers -> Sites -> Appointments. Example:
  # { "Customer Name" => {"site-id-1" => [appointment1, appointment2]
  #                       "site-id-2" => [appointment3, appointment4]
  #                       "no-site" => [appointmnet5]}}
  #
  def self.group_appointments_for_display(appointments)
    appointment_hash = {}
    customer_hash = {}
    appointments.each do |appt|
      if customer_hash[appt.agency_customer_id]
        customer_hash[appt.agency_customer_id] << appt
      else
        customer_hash[appt.agency_customer_id] = [appt]
      end
    end

    customer_hash.each do |k, v|
      customer = AgencyCustomer.find(k)
      sites_hash = {}

      v.each do |appt|
        if appt.site_id.blank?
          if sites_hash["no-site"]
            sites_hash["no-site"] << appt
          else
            sites_hash["no-site"] = [appt]
          end
        end

        if sites_hash[appt.site_id]
          sites_hash[appt.site_id] << appt
        else
          sites_hash[appt.site_id] = [appt]
        end
      end

      appointment_hash[customer.name] = sites_hash
    end

    appointment_hash
  end

  # Groups appointments into Interpreter ID => appointments. Example:
  # { "interpreter_id_1" => [appointment1, appointment2],
  #   "interpreter_id_2" => [appointment3, appointment4] }
  #
  def self.group_appointments_for_interpreter_display(appointments)
    appointment_hash = {}

    appointments.each do |appt|
      next if appt.interpreter_id.blank?

      if appointment_hash[appt.interpreter_id]
        appointment_hash[appt.interpreter_id] << appt
      else
        appointment_hash[appt.interpreter_id] = [appt]
      end
    end

    appointment_hash
  end

  def export!
    appointments.each do |appt|
      case batch_type
      when "customer"
        appt.update(status: "exported", processed_by_customer: true)
      when "interpreter"
        appt.update(status: "exported", processed_by_interpreter: true)
      end
    end
    update(is_processed: true)
  end

  def revert_batch!
    appointments.each do |appt|
      case batch_type
      when "customer"
        appt.update(status: "verified", processed_by_customer: false)
      when "interpreter"
        appt.update(status: "verified", processed_by_interpreter: false)
      end
    end
    update(is_processed: false)
  end

  def to_csv
    CSV.generate do |csv|
      csv << ["Customer", "Site", "Appointment ID", "Billing Details", "Amount Billed"]
      appointments.each do |appt|
        csv << [appt.agency_customer.name, appt&.site&.name || "", appt.refnumber, appt.billing_types, number_with_precision(appt.total_billed, precision: 2)]
      end
    end
  end

  def to_interpreter_csv
    CSV.generate do |csv|
      csv << ["Interpreter", "Appointment ID", "Amount Paid"]
      appointments.each do |appt|
        csv << [appt.interpreter&.last_first_name || "(Interpreter not found)", appt.refnumber, number_with_precision(appt.total_paid, precision: 2)]
      end
    end
  end

  private

  def set_process_batch_id
    last_process_batch = ProcessBatch.where.not(id: id)
      .where(account_id: account_id)
      .where.not(process_id: nil)
      .order(created_at: :desc)
      .limit(1)
      .first
    if last_process_batch.present?
      update_column(:process_id, last_process_batch.process_id + 1)
    else
      update_column(:process_id, 1)
    end
  end

  def associate_appointments
    start_date = Date.parse(self.start_date)
    end_date = Date.parse(self.end_date)
    case batch_type
    when "customer"
      appts = Appointment.where(agency_id: account_id)
        .where("start_time > ?", start_date.beginning_of_day)
        .where("start_time < ?", end_date.end_of_day)
        .where(status: Appointment.statuses[:verified])
        .where(processed_by_customer: false)
        .where(agency_customer_id: customer_ids)
    when "interpreter"
      appts = Appointment.where(agency_id: account_id)
        .where("start_time > ?", start_date.beginning_of_day)
        .where("start_time < ?", end_date.end_of_day)
        .where(status: Appointment.statuses[:verified])
        .where(processed_by_interpreter: false)
        .where(interpreter_id: interpreter_ids)
    end
    create_appointment_associations(appts) if appts.any?
  end

  def create_appointment_associations(appts)
    appts.each do |appt|
      ProcessBatchAppointment.create!(process_batch: self, appointment: appt)
    end
  end
end
