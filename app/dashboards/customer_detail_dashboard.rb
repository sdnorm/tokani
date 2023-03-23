require "administrate/base_dashboard"

class CustomerDetailDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    appointments_in_person: Field::Boolean,
    appointments_phone: Field::Boolean,
    appointments_video: Field::Boolean,
    contact_name: Field::String,
    customer: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ["name"]
    ),
    customer_category: Field::BelongsTo,
    email: Field::String,
    fax: Field::String,
    notes: Field::Text,
    phone: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    customer
    contact_name
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    appointments_in_person
    appointments_phone
    appointments_video
    contact_name
    customer
    customer_category
    email
    fax
    notes
    phone
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    appointments_in_person
    appointments_phone
    appointments_video
    contact_name
    customer
    customer_category
    email
    fax
    notes
    phone
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

  # Overwrite this method to customize how customer details are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(customer_detail)
  #   "CustomerDetail ##{customer_detail.id}"
  # end
end
