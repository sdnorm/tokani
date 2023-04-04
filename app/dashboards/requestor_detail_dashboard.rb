require "administrate/base_dashboard"

class RequestorDetailDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    allow_offsite: Field::Boolean,
    allow_view_checklist: Field::Boolean,
    allow_view_docs: Field::Boolean,
    customer: Field::BelongsTo,
    department: Field::BelongsTo,
    primary_phone: Field::String,
    requestor: Field::BelongsTo,
    requestor_type: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    site: Field::BelongsTo,
    work_phone: Field::String,
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
    allow_offsite
    allow_view_checklist
    allow_view_docs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    allow_offsite
    allow_view_checklist
    allow_view_docs
    customer
    department
    primary_phone
    requestor
    requestor_type
    site
    work_phone
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    allow_offsite
    allow_view_checklist
    allow_view_docs
    customer
    department
    primary_phone
    requestor
    requestor_type
    site
    work_phone
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

  # Overwrite this method to customize how requestor details are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(requestor_detail)
  #   "RequestorDetail ##{requestor_detail.id}"
  # end
end
