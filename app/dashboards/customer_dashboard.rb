require "administrate/base_dashboard"

class CustomerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String,
    account_invitations: Field::HasMany,
    account_languages: Field::HasMany,
    account_sites: Field::HasMany,
    account_users: Field::HasMany,
    addresses: Field::HasMany,
    agencies: Field::HasMany,
    agency: Field::Boolean,
    agency_customers: Field::HasMany,
    appointments: Field::HasMany,
    avatar_attachment: Field::HasOne,
    avatar_blob: Field::HasOne,
    billing_address: Field::HasOne,
    charges: Field::HasMany,
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
    notifications: Field::HasMany,
    owner: Field::BelongsTo,
    pay_bill_configs: Field::HasMany,
    pay_bill_rates: Field::HasMany,
    pay_customers: Field::HasMany,
    payment_processor: Field::HasOne,
    personal: Field::Boolean,
    physical_address: Field::HasOne,
    process_batches: Field::HasMany,
    providers: Field::HasMany,
    rate_criteria: Field::HasMany,
    recipients: Field::HasMany,
    reports: Field::HasMany,
    requestor_details: Field::HasMany,
    requestors: Field::HasMany,
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
  COLLECTION_ATTRIBUTES = %i[
    id
    account_invitations
    account_languages
    account_sites
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    account_invitations
    account_languages
    account_sites
    account_users
    addresses
    agencies
    agency
    agency_customers
    appointments
    avatar_attachment
    avatar_blob
    billing_address
    charges
    customer
    customer_agencies
    customer_appointments
    customer_detail
    customers
    domain
    extra_billing_info
    is_active
    languages
    name
    notifications
    owner
    pay_bill_configs
    pay_bill_rates
    pay_customers
    payment_processor
    personal
    physical_address
    process_batches
    providers
    rate_criteria
    recipients
    reports
    requestor_details
    requestors
    shipping_address
    sites
    specialties
    subdomain
    subscriptions
    users
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    account_invitations
    account_languages
    account_sites
    account_users
    addresses
    agencies
    agency
    agency_customers
    appointments
    avatar_attachment
    avatar_blob
    billing_address
    charges
    customer
    customer_agencies
    customer_appointments
    customer_detail
    customers
    domain
    extra_billing_info
    is_active
    languages
    name
    notifications
    owner
    pay_bill_configs
    pay_bill_rates
    pay_customers
    payment_processor
    personal
    physical_address
    process_batches
    providers
    rate_criteria
    recipients
    reports
    requestor_details
    requestors
    shipping_address
    sites
    specialties
    subdomain
    subscriptions
    users
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

  # Overwrite this method to customize how customers are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(customer)
  #   "Customer ##{customer.id}"
  # end
end
