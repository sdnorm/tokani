# == Schema Information
#
# Table name: accounts
#
#  id                  :uuid             not null, primary key
#  account_users_count :integer          default(0)
#  agency              :boolean
#  billing_email       :string
#  customer            :boolean          default(FALSE)
#  domain              :string
#  extra_billing_info  :text
#  is_active           :boolean          default(TRUE)
#  name                :string           not null
#  personal            :boolean          default(FALSE)
#  subdomain           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :uuid
#
# Indexes
#
#  index_accounts_on_created_at  (created_at)
#  index_accounts_on_owner_id    (owner_id)
#
class Agency < Account
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :agencies, partial: "agencies/index", locals: {agency: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :agencies, target: dom_id(self, :index) }

  before_create :set_agency_flag

  has_one :physical_address, -> { where(address_type: :physical) }, class_name: "Address", as: :addressable
  validates_presence_of :physical_address
  accepts_nested_attributes_for :physical_address

  def create_owner_account_from_primary_contact
    user = User.new(
      email: agency_detail.primary_contact_email,
      password: SecureRandom.alphanumeric,
      first_name: agency_detail.primary_contact_first_name,
      last_name: agency_detail.primary_contact_last_name,
      terms_of_service: true,
      time_zone: agency_detail.time_zone,
      accepted_terms_at: Time.current
    )
    if user.save
      update(owner_id: user.id)
      account_users.create(user: user, roles: {agency_admin: true, admin: true})
      TokaniAgencyCreationMailer.welcome(user).deliver_later
    else
      raise "Could not save User in Agency#create_user_and_owner - #{user.errors.full_messages.join("; ")}"
    end
  end

  def create_example_agency_data
    language = Language.create!(name: "Spanish", is_active: true, account_id: id)
    Language.create!(name: "French", is_active: true, account_id: id)
    cust_category = CustomerCategory.create!(display_value: "Medical Example", appointment_prefix: "ME", telephone_prefix: "MET", video_prefix: "MEV", is_active: true, account_id: id)
    CustomerCategory.create!(display_value: "Education Example", appointment_prefix: "EE", telephone_prefix: "EET", video_prefix: "EEV", is_active: true, account_id: id)
    ChecklistType.create!(name: "Covid Vaccine", format: 1, requires_expiration: true, is_active: true, account_id: id)
    BillRate.create!(
      account_id: id,
      name: "Example Bill Rate",
      hourly_bill_rate: 0.1e3,
      is_active: true,
      minimum_time_charged: 60,
      round_time: "round_up",
      round_increment: 20,
      after_hours_overage: 0.3e2,
      regular_hours_start_seconds: 25200,
      regular_hours_end_seconds: 64800,
      rush_overage: 0.6e2,
      rush_overage_trigger: 48,
      cancel_rate: 0.1e3,
      cancel_rate_trigger: 48,
      default_rate: true,
      in_person: true,
      phone: true,
      video: true
    )
    PayRate.create!(
      account_id: id,
      name: "Example Pay Rate",
      hourly_pay_rate: 0.65e2,
      is_active: true,
      minimum_time_charged: 75,
      after_hours_overage: 0.85e2,
      rush_overage: 0.1e3,
      cancel_rate: 0.5e2,
      default_rate: true,
      in_person: true,
      phone: true,
      video: true
    )

    interpreter = User.new(
      email: Faker::Internet.email(domain: "example"),
      password: SecureRandom.alphanumeric,
      first_name: "Example",
      last_name: "Interpreter",
      terms_of_service: true,
      time_zone: "Pacific Time (US & Canada)",
      accepted_terms_at: Time.current
    )
    if interpreter.save
      AccountUser.create!(user_id: interpreter.id, roles: {"interpreter" => true}, account_id: id)
      InterpreterDetail.create!(
        interpreter_type: 1,
        gender: 2,
        address: "123 Example Lane",
        city: "Example Town",
        state: "CA",
        zip: "12345",
        primary_phone: "123-123-1234",
        time_zone: "Pacific Time (US & Canada)",
        interpreter_id: interpreter.id
      )
      InterpreterLanguage.create!(language_id: language.id, interpreter_id: interpreter.id)
    else
      raise "Could not save Interpreter in Agency#create_example_agency_data - #{interpreter.errors.full_messages.join("; ")}"
    end

    customer = Account.create!(
      name: "Example Hospital",
      customer: true
    )
    Address.create!(
      addressable_type: "Account",
      address_type: "physical",
      line1: "11 Example Way",
      line2: "",
      city: "Example",
      state: "CA",
      postal_code: "66654",
      addressable_id: customer.id
    )

    CustomerDetail.create!(
      contact_name: "Example Customer",
      email: Faker::Internet.email(domain: "example"),
      fax: "333-333-3333",
      notes: "example notes",
      phone: "222-222-2222",
      appointments_in_person: true,
      appointments_phone: true,
      appointments_video: true,
      customer_id: customer.id,
      customer_category_id: cust_category.id
    )
    cust_user = User.new(
      name: customer.customer_detail.contact_name,
      email: customer.customer_detail.email,
      password: SecureRandom.alphanumeric,
      time_zone: "Pacific Time (US & Canada)",
      terms_of_service: true,
      accepted_terms_at: Time.current
    )

    if cust_user.save
      customer.update(owner_id: cust_user.id)
      AccountUser.create!(user_id: cust_user.id, roles: {"customer_admin" => true}, account_id: customer.id)
      RequestorDetail.create!(
        allow_offsite: true,
        allow_view_docs: true,
        allow_view_checklist: true,
        primary_phone: customer.customer_detail.phone,
        customer_id: customer.id,
        requestor_id: cust_user.id,
        requestor_type: 4
      )
      CustomerRequestor.create!(customer_id: customer.id, requestor_id: cust_user.id)
      AgencyCustomer.create!(agency_id: id, customer_id: customer.id)
    else
      raise "Could not save customer_user in Agency#create_example_agency_data - #{cust_user.errors.full_messages.join("; ")}"
    end

    site = Site.create!(
      name: "Example Site",
      contact_name: "Site Contact",
      email: "site@example.com",
      address: "123 Site Lane",
      city: "Site Town",
      state: "AZ",
      zip_code: "45678",
      active: true,
      contact_phone: "333-999-8888",
      customer_id: customer.id,
      account_id: id
    )

    Department.create!(
      name: "Example Department",
      location: "Main Location",
      accounting_unit_code: "443",
      accounting_unit_desc: nil,
      is_active: true,
      site_id: site.id
    )

    provider = Provider.create!(
      last_name: "Provider",
      first_name: "Example",
      email: Faker::Internet.email(domain: "example"),
      primary_phone: "444-555-8990",
      allow_text: true,
      allow_email: false,
      site_id: site.id,
      department_id: nil,
      customer_id: customer.id
    )

    recipient = Recipient.create!(
      last_name: "Recipient",
      first_name: "Example",
      email: "recipient@example",
      primary_phone: "555-555-8990",
      mobile_phone: "555-555-8991",
      srn: "EXAMPLE",
      allow_text: true,
      allow_email: true,
      customer_id: customer.id
    )

    # create_example_appointments - open, offered, scheduled

    unless site.nil? || language.nil? || provider.nil? || cust_user.nil?
      Appointment.create!(
        agency_id: id,
        customer_id: customer.id,
        site_id: site.id,
        time_zone: "Pacific Time (US & Canada)",
        start_time: Time.now.beginning_of_hour + rand(1..10).days,
        duration: 45,
        modality: 1,
        language_id: language.id,
        requestor_id: cust_user.id,
        provider_id: provider.id,
        creator_id: cust_user.id,
        recipient_id: recipient.id,
        interpreter_type: 1,
        gender_req: 2,
        viewable_by: 0
      )

      Appointment.create!(
        agency_id: id,
        customer_id: customer.id,
        site_id: site.id,
        time_zone: "Pacific Time (US & Canada)",
        start_time: Time.now.beginning_of_hour + rand(1..10).days,
        duration: 60,
        modality: 1,
        language_id: language.id,
        requestor_id: cust_user.id,
        provider_id: provider.id,
        creator_id: cust_user.id,
        recipient_id: recipient.id,
        interpreter_type: 2,
        interpreter_req_ids: [interpreter.id]
      )

      Appointment.create!(
        agency_id: id,
        customer_id: customer.id,
        site_id: site.id,
        time_zone: "Pacific Time (US & Canada)",
        start_time: Time.now.beginning_of_hour + rand(1..10).days,
        duration: 60,
        modality: 1,
        language_id: language.id,
        requestor_id: cust_user.id,
        provider_id: provider.id,
        creator_id: cust_user.id,
        recipient_id: recipient.id,
        assigned_interpreter: interpreter.id
      )

    end
  end

  private

  def set_agency_flag
    self.agency = true
  end
end
