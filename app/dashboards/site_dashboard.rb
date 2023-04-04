require "administrate/base_dashboard"

class SiteDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String,
    account: Field::BelongsTo,
    active: Field::Boolean,
    address: Field::String,
    backport_id: Field::Number,
    city: Field::String,
    contact_name: Field::String,
    contact_phone: Field::String,
    customer: Field::BelongsTo,
    departments: Field::HasMany,
    email: Field::String,
    name: Field::String,
    notes: Field::Text,
    providers: Field::HasMany,
    requestor_details: Field::HasMany,
    state: Field::String,
    zip_code: Field::String,
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
    account
    active
    address
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    account
    active
    address
    backport_id
    city
    contact_name
    contact_phone
    customer
    departments
    email
    name
    notes
    providers
    requestor_details
    state
    zip_code
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    account
    active
    address
    backport_id
    city
    contact_name
    contact_phone
    customer
    departments
    email
    name
    notes
    providers
    requestor_details
    state
    zip_code
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

  # Overwrite this method to customize how sites are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(site)
  #   "Site ##{site.id}"
  # end
end
