require "administrate/base_dashboard"

class AccountDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    owner: Field::BelongsTo.with_options(class_name: "User"),
    pay_customers: Field::HasMany.with_options(class_name: "Pay::Customer"),
    charges: Field::HasMany.with_options(class_name: "Pay::Charge"),
    subscriptions: Field::HasMany.with_options(class_name: "Pay::Subscription"),
    account_users: Field::HasMany,
    users: Field::HasMany,
    avatar: Field::ActiveStorage,
    id: Field::String,
    account_invitations: Field::HasMany,
    account_languages: Field::HasMany,
    account_sites: Field::HasMany,
    account_users: Field::HasMany,
    account_users_count: Field::Number,
    addresses: Field::HasMany,
    agencies: Field::HasMany,
    agency: Field::Boolean,
    agency_customers: Field::HasMany,
    agency_detail: Field::HasOne,
    agency_recipients: Field::HasMany,
    appointments: Field::HasMany,
    bill_rates: Field::HasMany,
    billing_address: Field::HasOne,
    billing_email: Field::String,
    charges: Field::HasMany,
    checklist_types: Field::HasMany,
    customer: Field::Boolean,
    customer_agencies: Field::HasMany,
    customer_appointments: Field::HasMany,
    customer_detail: Field::HasOne,
    customers: Field::HasMany,
    domain: Field::String,
    extra_billing_info: Field::Text,
    is_active: Field::Boolean,
    languages: Field::HasMany,
    name: Field::String,
    notification_email: Field::HasOne,
    notifications: Field::HasMany,
    owner: Field::BelongsTo,
    pay_customers: Field::HasMany,
    pay_rates: Field::HasMany,
    payment_processor: Field::HasOne,
    personal: Field::Boolean,
    physical_address: Field::HasOne,
    process_batches: Field::HasMany,
    providers: Field::HasMany,
    rate_criteria: Field::HasMany,
    recipients: Field::HasMany,
    reports: Field::HasMany,
    requestor_details: Field::HasMany,
    shipping_address: Field::HasOne,
    sites: Field::HasMany,
    specialties: Field::HasMany,
    subdomain: Field::String,
    subscriptions: Field::HasMany,
    users: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    # :id,
    :name,
    :owner,
    :agency,
    :account_users
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :owner,
    :pay_customers,
    :charges,
    :subscriptions,
    :account_users,
    :users,
    :avatar,
    :name,
    :customer,
    :personal,
    :created_at,
    :updated_at,
    :extra_billing_info
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :owner,
    :name,
    :customer,
    :agency,
    # :customer_id,
    :personal,
    :extra_billing_info
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how accounts are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(account)
    account.name.to_s
  end
end
