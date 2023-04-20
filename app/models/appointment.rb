# == Schema Information
#
# Table name: appointments
#
#  id                        :bigint           not null, primary key
#  admin_notes               :text
#  assigned_interpreter      :uuid
#  billing_notes             :text
#  cancel_reason_code        :integer
#  cancel_type               :integer
#  canceled_by               :integer
#  cancelled_at              :datetime
#  confirmation_date         :datetime
#  confirmation_notes        :text
#  confirmation_phone        :string
#  current_status            :string
#  details                   :text
#  duration                  :integer
#  finish_time               :datetime
#  gender_req                :integer
#  home_health_appointment   :boolean
#  interpreter_reminder_sent :boolean          default(FALSE)
#  interpreter_type          :integer
#  lock_version              :integer
#  modality                  :integer
#  notes                     :text
#  processed_by_customer     :boolean          default(FALSE)
#  processed_by_interpreter  :boolean          default(FALSE)
#  ref_number                :string
#  start_time                :datetime
#  status                    :boolean
#  sub_type                  :integer
#  time_zone                 :string
#  total_billed              :decimal(, )
#  total_paid                :decimal(, )
#  video_link                :string
#  viewable_by               :integer
#  visibility_status         :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  agency_id                 :uuid
#  bill_rate_id              :integer
#  creator_id                :uuid
#  customer_id               :uuid
#  department_id             :uuid
#  interpreter_id            :uuid
#  language_id               :bigint           not null
#  pay_rate_id               :integer
#  provider_id               :uuid
#  recipient_id              :uuid
#  requestor_id              :uuid
#  site_id                   :uuid
#
# Indexes
#
#  index_appointments_on_agency_id       (agency_id)
#  index_appointments_on_customer_id     (customer_id)
#  index_appointments_on_department_id   (department_id)
#  index_appointments_on_interpreter_id  (interpreter_id)
#  index_appointments_on_language_id     (language_id)
#  index_appointments_on_provider_id     (provider_id)
#  index_appointments_on_recipient_id    (recipient_id)
#  index_appointments_on_requestor_id    (requestor_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (provider_id => providers.id)
#  fk_rails_...  (recipient_id => recipients.id)
#  fk_rails_...  (requestor_id => users.id)
#  fk_rails_...  (site_id => sites.id)
#
class Appointment < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :appointments, partial: "appointments/index", locals: {appointment: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :appointments, target: dom_id(self, :index) }

  # has_many :appointment_languages, dependent: :destroy
  has_many :appointment_specialties, dependent: :destroy
  has_many :specialties, through: :appointment_specialties
  has_many :appointment_statuses, dependent: :destroy
  has_many :billing_line_items, dependent: :destroy
  has_many :payment_line_items, dependent: :destroy
  has_many :requested_interpreters, dependent: :destroy
  has_many :offered_interpreters, through: :requested_interpreters, foreign_key: "user_id", source: :interpreter

  belongs_to :language
  belongs_to :creator, class_name: "User", optional: true
  belongs_to :agency, class_name: "Account"
  belongs_to :customer, class_name: "Account"
  belongs_to :interpreter, class_name: "User", optional: true
  belongs_to :site
  belongs_to :department, optional: true
  belongs_to :requestor, class_name: "User"
  belongs_to :provider, optional: true
  belongs_to :recipient, optional: true
  belongs_to :bill_rate, optional: true
  belongs_to :pay_rate, optional: true

  has_many_attached :documents

  enum gender_req: {male: 1, female: 2, non_binary: 3}
  enum modality: {in_person: 1, phone: 2, video: 3}
  enum interpreter_type: {general: 1, specific: 2, assigned: 3}
  enum viewable_by: {admin: -1, all: 0, staff: 1, independent_contractor: 2, agency: 3, volunteer: 4, none: 5}, _suffix: "itype_filter"
  enum cancel_type: {agency: 0, requestor: 1}
  enum visibility_status: {offered: 0, opened: 1}

  scope :by_status, ->(status) { where(status: status) }
  scope :by_appointment_specific_status, ->(name) { joins(:appointment_statuses).where(appointment_statuses: {name: name}) }
  scope :by_customer_name, ->(name) { includes(:customer).where(customer: {name: name}) }
  scope :sort_by_account_name, -> { includes(:customer).order("accounts.name ASC") }

  attr_accessor :interpreter_req_ids, :submitted_finish_date, :submitted_finish_time

  validates :start_time, :modality, :duration, :language_id, :requestor_id, presence: true
  validate :valid_video_link
  before_create :gen_refnum

  after_create :send_created_notifications
  after_create :create_offers, if: :no_assignment?
  after_create :assign_interpreter, unless: :no_assignment?
  # after_update :update_offers, if: :unless_no_offers
  after_update :update_offers
  after_update :add_assigned_int
  after_update :assign_interpreter, if: :assigned_interpreter_changed?
  before_update :send_edited_notifications

  def no_assignment?
    assigned_interpreter.nil?
  end

  def assign_interpreter
    update(interpreter_id: assigned_interpreter)
    AppointmentStatus.create(appointment: self, name: AppointmentStatus.names["scheduled"], user: User.find(assigned_interpreter))
  end

  def add_assigned_int
    if !interpreter_id.nil? && assigned_interpreter.nil?
      update_columns(assigned_interpreter: interpreter_id)
    end
  end

  #  **** per conversation on 2/23/22, the team is OK with the fact that this WILL create collisions.
  def gen_refnum
    category_code = customer&.customer_detail&.customer_category&.modality_prefix(modality)
    # here's where our collision occurs.
    my_year = Time.current.year
    year_code = (my_year - 2000).to_s
    appointment_number = Appointment.where("created_at >= :date", date: "#{my_year}-01-01").count
    final_num = (appointment_number + 1).to_s.rjust(3, "0")
    # Added a temporary category code sample to bypass the bug here
    self.ref_number = "#{category_code || [100, 101, 102].sample}-#{year_code}-#{final_num}"
  end

  def create_status_for_new_appt
    status_check = AppointmentStatus.where(appointment_id: id)
    return unless status_check.blank?

    new_status = (visibility_status == "opened") ? "opened" : "offered"
    AppointmentStatus.create!(name: new_status, user_id: creator_id, appointment_id: id)

    nil
  end

  def set_visibility_status
    vis_status = if (interpreter_req_ids.blank? || interpreter_req_ids.class != Array) || interpreter_req_ids.compact_blank.empty?
      "opened"
    else
      "offered"
    end
    update_columns(visibility_status: vis_status)
  end

  def create_offers
    set_visibility_status
    create_status_for_new_appt
    # shortcircuit for no requesting ids
    return true if interpreter_req_ids.blank? || interpreter_req_ids.class != Array
    return true if interpreter_req_ids.compact_blank.empty?

    offered = false
    interpreter_req_ids.uniq.each do |int_req_id|
      new_int_req = RequestedInterpreter.new(user_id: int_req_id, appointment_id: id)

      begin
        offered = new_int_req.save! || offered
      rescue => e
        errors.add(:base, "Something went wrong with creating an offer")
        logger.info "Failed creation of offer to IntID: #{int_req_id} to #{id}.  Error: #{e}"
        throw ActiveRecord::RecordInvalid
      end
    end

    if offered
      NotificationsService.deliver_appointment_offered_notifications(account: agency, appointment: self)
    end
  end

  def unless_no_offers
    requested_interpreters.nil?
  end

  def no_offers
    requested_interpreters.nil?
  end

  def update_offers
    # return if current_status == "offered" || current_status == "scheduled" || current_status == "completed" || current_status == "cancelled"
    # An empty array causes a delete, but nil, does nothing
    # if interpreter_req_ids.nil? || interpreter_req_ids == "" || interpreter_req_ids.class != Array
    #   if status != "opened"
    #     AppointmentStatus.create!(name: "opened", user_id: creator_id, appointment_id: id)
    #   end
    #   return true
    # end
    return true if interpreter_req_ids.nil? || interpreter_req_ids == "" || interpreter_req_ids.class != Array
    current_offer_int_ids = requested_interpreters.map(&:user_id)
    new_offer_int_ids = interpreter_req_ids.compact_blank.uniq

    # if interpreter_req_ids.nil? || interpreter_req_ids == "" || interpreter_req_ids.class != Array
    #   new_offer_int_ids = []

    # else
    #   new_offer_int_ids = interpreter_req_ids.compact_blank.uniq
    # end

    # Nothing to do here....
    return true if current_offer_int_ids.blank? && new_offer_int_ids.blank?

    offers_to_add_by_int = new_offer_int_ids - current_offer_int_ids
    offers_to_remove_by_int_id = current_offer_int_ids - new_offer_int_ids

    removed_offers = RequestedInterpreter.where(user_id: offers_to_remove_by_int_id)
    RequestedInterpreter.destroy(removed_offers.map(&:id))

    offers_to_add_by_int.each do |int_req_id|
      new_int_req = RequestedInterpreter.new(user_id: int_req_id, appointment_id: id)
      begin
        new_int_req.save!
      rescue => e
        errors.add(:base, "Something went wrong with creating an offer")
        logger.info "Failed creation of offer to IntID: #{int_req_id} to #{id}.  Error: #{e}"
        throw ActiveRecord::RecordInvalid
      end
    end

    new_apt_status = if offers_to_add_by_int.empty? && !offers_to_remove_by_int_id.empty? && ((current_offer_int_ids - offers_to_remove_by_int_id == []))
      # Changing appointment status back to opened
      update_columns(visibility_status: "opened") unless visibility_status == "opened"
      AppointmentStatus.new(user_id: creator_id, appointment_id: id, name: "opened")
    else
      NotificationsService.deliver_appointment_offered_notifications(account: agency, appointment: self)
      update_columns(visibility_status: "offered") unless visibility_status == "offered"
      AppointmentStatus.new(user_id: creator_id, appointment_id: id, name: "offered")
    end

    begin
      new_apt_status.save!
    rescue => e
      errors.add(:base, "Something went wrong with creating a new appointment status")
      logger.info "Failed creation of appt status: #{creator_id} to #{id}.  Error: #{e}"
      throw ActiveRecord::RecordInvalid
    end
  end

  def status
    appointment_statuses.current.name
  end

  # User this method before the appointment is marked as completed with an actual finish_time
  def end_time
    if duration.present?
      start_time + duration.minutes
    else
      raise "Appointment#end_time called on an appointment without a duration"
    end
  end

  def start_time_with_zone
    start_time.in_time_zone(time_zone)
  end

  def end_time_with_zone
    end_time.in_time_zone(time_zone)
  end

  def finish_time_with_zone
    finish_time.in_time_zone(time_zone)
  end

  def start_time_in_zone(zone)
    start_time.in_time_zone(zone)
  end

  def start_datetime_string_in_zone(zone)
    dt = start_time_in_zone(zone)
    dt.strftime("%B %-d at %I:%M %p (%Z)")
  end

  def associate_bill_rate_via_service
    service = BillRateDeterminationService.new(self)
    rate = service.determine_bill_rate
    update_column(:bill_rate_id, rate.id) if rate.present?
  end

  def associate_pay_rate_via_service
    service = PayRateDeterminationService.new(self)
    rate = service.determine_pay_rate
    update_column(:pay_rate_id, rate.id) if rate.present?
  end

  def create_line_items_and_save_totals
    return unless bill_rate_id.present? && pay_rate_id.present?

    service = RateCalculatorService.new(self)

    billing_line_items.destroy_all
    BillingLineItem.persist_from_struct(self, service.billing_line_items)

    payment_line_items.destroy_all
    PaymentLineItem.persist_from_struct(self, service.payment_line_items)

    update_columns(total_billed: service.total_bill,
      total_paid: service.total_pay)
  end

  def calculated_appointment_duration_in_hours
    return nil unless start_time.present? && finish_time.present?

    TimeDifference.between(start_time, finish_time).in_hours
  end

  def calculated_appointment_duration_in_minutes
    return nil unless start_time.present? && finish_time.present?

    TimeDifference.between(start_time, finish_time).in_minutes
  end

  def starts_on_weekday?
    return nil if start_time.blank?

    # Use wday to determine start day. 0-6, Sunday is 0
    [1, 2, 3, 4, 5].include?(start_time_with_zone.wday)
  end

  def billing_types
    billing_line_items.map { |li| li.type_key.titleize }.join(" - ")
  end

  def payment_types
    payment_line_items.map { |li| li.type_key.titleize }.join(" - ")
  end

  def duration_in_hours(round_to = 0)
    (duration / 60.0).round(round_to)
  end

  def duration_viewable
    "#{duration} minutes"
  end

  def less_than_24_hours_left_until_appointment?
    TimeDifference.between(DateTime.now.utc, start_time).in_hours < 24
  end

  def combine_finish_date_and_time(date_portion, time_portion, user)
    Time.zone = user.time_zone
    time = Time.zone.parse(time_portion)
    date = Time.zone.parse(date_portion).to_date
    parsed_datetime_in_zone = Time.zone.parse("#{date.strftime("%F")} #{time.strftime("%T")}")
    self.finish_time = parsed_datetime_in_zone.utc
  end

  def time_finished?
    ["finished", "verified", "exported"].include?(status)
  end

  def verified?
    ["verified", "exported"].include?(status)
  end

  def send_created_notifications
    NotificationsService.deliver_appointment_created_notifications(account: agency, appointment: self)
  end

  def send_edited_notifications
    # We only want to send these if certain fields are updated:
    # Date or Time Change, Modality, Location or Duration
    check_for_change_fields = ["start_time", "modality", "site_id", "department_id", "duration"]
    # Find the common elements of the two arrays
    if (check_for_change_fields & changed).any?
      NotificationsService.deliver_appointment_edited_notifications(account: agency, appointment: self)
    end
  end


  def can_schedule?
    status == "opened" || status == "offered"
  end
  # commenting this out because standardrb showed two methods in this model with this name
  # def end_time
  #   Time.zone.at(start_time + duration)
  # end

  def to_tsrange
    duration_in_seconds = duration * 60
    start_time..(start_time + duration_in_seconds)

  def video_modality?
    modality == "video"
  end

  def valid_video_link
    return true if video_link.blank?

    errors.add(:video_link, "must start with https:// or http://") unless video_link.downcase.start_with?("https://", "http://")
    false

  end
end
