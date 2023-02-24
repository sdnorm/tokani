require "administrate/base_dashboard"

class CustomerCategoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    appointment_prefix: Field::String,
    backport_id: Field::Number,
    customer_details: Field::HasMany,
    customers: Field::HasMany,
    display_value: Field::String,
    is_active: Field::Boolean,
    sort_order: Field::Number,
    telephone_prefix: Field::String,
    video_prefix: Field::String,
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
    appointment_prefix
    backport_id
    customer_details
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    appointment_prefix
    backport_id
    customer_details
    customers
    display_value
    is_active
    sort_order
    telephone_prefix
    video_prefix
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    appointment_prefix
    backport_id
    customer_details
    customers
    display_value
    is_active
    sort_order
    telephone_prefix
    video_prefix
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

  # Overwrite this method to customize how customer categories are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(customer_category)
  #   "CustomerCategory ##{customer_category.id}"
  # end
end
