require "administrate/base_dashboard"

class AgencyDetailDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    agency: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ["name"]
    ),
    company_website: Field::String,
    phone_number: Field::String,
    primary_contact_email: Field::String,
    primary_contact_first_name: Field::String,
    primary_contact_last_name: Field::String,
    primary_contact_phone_number: Field::String,
    primary_contact_title: Field::String,
    secondary_contact_email: Field::String,
    secondary_contact_first_name: Field::String,
    secondary_contact_last_name: Field::String,
    secondary_contact_phone_number: Field::String,
    secondary_contact_title: Field::String,
    time_zone: Field::String,
    time_zones: Field::String,
    url: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    agency
    primary_contact_first_name
    primary_contact_last_name
    primary_contact_email
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    agency
    company_website
    phone_number
    primary_contact_email
    primary_contact_first_name
    primary_contact_last_name
    primary_contact_phone_number
    primary_contact_title
    secondary_contact_email
    secondary_contact_first_name
    secondary_contact_last_name
    secondary_contact_phone_number
    secondary_contact_title
    time_zone
    time_zones
    url
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    agency
    company_website
    phone_number
    primary_contact_email
    primary_contact_first_name
    primary_contact_last_name
    primary_contact_phone_number
    primary_contact_title
    secondary_contact_email
    secondary_contact_first_name
    secondary_contact_last_name
    secondary_contact_phone_number
    secondary_contact_title
    time_zone
    time_zones
    url
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

  # Overwrite this method to customize how agency details are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(agency_detail)
  #   "AgencyDetail ##{agency_detail.id}"
  # end
end
