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

  attr_accessor :start_date, :end_date, :customer_ids, :interpreter_ids, :current_user

  # Groups appointments into Customers -> Sites -> Appointments. Example:
  # { "Customer Name" => {"site-id-1" => [appointment1, appointment2]
  #                       "site-id-2" => [appointment3, appointment4]
  #                       "no-site" => [appointmnet5]}}
  #
  def self.group_appointments_for_display(appointments)
    appointment_hash = {}
    customer_hash = {}
    appointments.each do |appt|
      if customer_hash[appt.customer_id]
        customer_hash[appt.customer_id] << appt
      else
        customer_hash[appt.customer_id] = [appt]
      end
    end

    customer_hash.each do |k, v|
      customer = Account.where(id: k, customer: true).first
      sites_hash = {}

      v.each do |appt|
        if appt.site_id.blank?
          if sites_hash["no-site"]
            sites_hash["no-site"] << appt
          else
            sites_hash["no-site"] = [appt]
          end
        elsif sites_hash[appt.site_id]
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
        appt.update(processed_by_customer: true)
      when "interpreter"
        appt.update(processed_by_interpreter: true)
      end
      if appt.processed_by_customer && appt.processed_by_interpreter
        # If the appointment has been processed by both customer & interpreter, mark the entire appointment as exported
        AppointmentStatus.create!(appointment: appt, user: current_user, name: AppointmentStatus.names["exported"])
      end
    end
    update(is_processed: true)
  end

  def revert_batch!(current_user)
    appointments.each do |appt|
      case batch_type
      when "customer"
        appt.update(processed_by_customer: false)
      when "interpreter"
        appt.update(processed_by_interpreter: false)
      end
      AppointmentStatus.create!(appointment: appt, user: current_user, name: AppointmentStatus.names["verified"])
    end
    update(is_processed: false)
  end

  def to_csv
    CSV.generate do |csv|
      csv << ["Customer", "Site", "Appointment ID", "Billing Details", "Amount Billed"]
      appointments.each do |appt|
        csv << [appt.customer.name, appt&.site&.name || "", appt.ref_number, appt.billing_types, number_with_precision(appt.total_billed, precision: 2)]
      end
    end
  end

  def to_interpreter_csv
    CSV.generate do |csv|
      csv << ["Interpreter", "Appointment ID", "Amount Paid"]
      appointments.each do |appt|
        csv << [appt.interpreter&.name || "(Interpreter not found)", appt.ref_number, number_with_precision(appt.total_paid, precision: 2)]
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
        .where(processed_by_customer: false)
        .where(customer_id: customer_ids)
      appts = appts.to_a.select { |appt| appt.status = "verified" }
    when "interpreter"
      appts = Appointment.where(agency_id: account_id)
        .where("start_time > ?", start_date.beginning_of_day)
        .where("start_time < ?", end_date.end_of_day)
        .where(processed_by_interpreter: false)
        .where(interpreter_id: interpreter_ids)
      appts = appts.to_a.select { |appt| appt.status = "verified" }
    end
    create_appointment_associations(appts) if appts.any?
  end

  def create_appointment_associations(appts)
    appts.each do |appt|
      ProcessBatchAppointment.create!(process_batch: self, appointment: appt)
    end
  end
end
