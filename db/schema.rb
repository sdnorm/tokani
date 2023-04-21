# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_21_222517) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "account_invitations", force: :cascade do |t|
    t.string "token", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.jsonb "roles", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "invited_by_id"
    t.uuid "account_id", null: false
    t.index ["account_id"], name: "index_account_invitations_on_account_id"
    t.index ["invited_by_id"], name: "index_account_invitations_on_invited_by_id"
    t.index ["token"], name: "index_account_invitations_on_token", unique: true
  end

  create_table "account_users", force: :cascade do |t|
    t.jsonb "roles", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.uuid "account_id"
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "personal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "extra_billing_info"
    t.string "domain"
    t.string "subdomain"
    t.uuid "owner_id"
    t.boolean "customer", default: false
    t.string "billing_email"
    t.boolean "is_active", default: true
    t.boolean "agency"
    t.integer "account_users_count", default: 0
    t.index ["created_at"], name: "index_accounts_on_created_at"
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "action_text_embeds", force: :cascade do |t|
    t.string "url"
    t.jsonb "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.integer "address_type"
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "addressable_id", null: false
  end

  create_table "agency_customers", force: :cascade do |t|
    t.uuid "agency_id"
    t.uuid "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_category_id"
    t.index ["agency_id"], name: "index_agency_customers_on_agency_id"
    t.index ["customer_category_id"], name: "index_agency_customers_on_customer_category_id"
    t.index ["customer_id"], name: "index_agency_customers_on_customer_id"
  end

  create_table "agency_details", force: :cascade do |t|
    t.string "url"
    t.string "phone_number"
    t.string "primary_contact_first_name"
    t.string "primary_contact_last_name"
    t.string "primary_contact_title"
    t.string "primary_contact_email"
    t.string "primary_contact_phone_number"
    t.string "secondary_contact_first_name"
    t.string "secondary_contact_last_name"
    t.string "secondary_contact_title"
    t.string "secondary_contact_email"
    t.string "secondary_contact_phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "agency_id"
    t.string "time_zones", array: true
    t.string "company_website"
    t.string "time_zone"
    t.index ["agency_id"], name: "index_agency_details_on_agency_id"
  end

  create_table "announcements", force: :cascade do |t|
    t.string "kind"
    t.string "title"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_tokens", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.jsonb "metadata", default: {}
    t.boolean "transient", default: false
    t.datetime "last_used_at", precision: nil
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["token"], name: "index_api_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_api_tokens_on_user_id"
  end

  create_table "appointment_specialties", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.bigint "specialty_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_appointment_specialties_on_appointment_id"
    t.index ["specialty_id"], name: "index_appointment_specialties_on_specialty_id"
  end

  create_table "appointment_statuses", force: :cascade do |t|
    t.integer "name"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "current"
    t.bigint "appointment_id"
    t.index ["appointment_id"], name: "index_appointment_statuses_on_appointment_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.string "ref_number"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.integer "duration"
    t.integer "modality"
    t.integer "sub_type"
    t.integer "gender_req"
    t.text "admin_notes"
    t.text "notes"
    t.text "details"
    t.boolean "status"
    t.integer "interpreter_type"
    t.text "billing_notes"
    t.integer "canceled_by"
    t.integer "cancel_reason_code"
    t.integer "lock_version"
    t.string "time_zone"
    t.datetime "confirmation_date"
    t.string "confirmation_phone"
    t.text "confirmation_notes"
    t.boolean "home_health_appointment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "interpreter_id"
    t.uuid "agency_id"
    t.uuid "customer_id"
    t.boolean "processed_by_customer", default: false
    t.boolean "processed_by_interpreter", default: false
    t.uuid "site_id"
    t.decimal "total_billed"
    t.decimal "total_paid"
    t.datetime "cancelled_at"
    t.integer "cancel_type"
    t.bigint "language_id", null: false
    t.string "video_link"
    t.uuid "department_id"
    t.uuid "provider_id"
    t.uuid "recipient_id"
    t.uuid "requestor_id"
    t.uuid "creator_id"
    t.integer "visibility_status"
    t.string "current_status"
    t.integer "bill_rate_id"
    t.integer "pay_rate_id"
    t.uuid "assigned_interpreter"
    t.boolean "interpreter_reminder_sent", default: false
    t.integer "viewable_by"
    t.index ["agency_id"], name: "index_appointments_on_agency_id"
    t.index ["customer_id"], name: "index_appointments_on_customer_id"
    t.index ["department_id"], name: "index_appointments_on_department_id"
    t.index ["interpreter_id"], name: "index_appointments_on_interpreter_id"
    t.index ["language_id"], name: "index_appointments_on_language_id"
    t.index ["provider_id"], name: "index_appointments_on_provider_id"
    t.index ["recipient_id"], name: "index_appointments_on_recipient_id"
    t.index ["requestor_id"], name: "index_appointments_on_requestor_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "time_zone"
    t.integer "wday"
    t.integer "start_seconds"
    t.integer "end_seconds"
    t.boolean "in_person"
    t.boolean "phone"
    t.boolean "video"
    t.integer "backport_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "start_seconds", "end_seconds"], name: "user_start_secs_end_secs_ix"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
    t.check_constraint "end_seconds >= 0 AND end_seconds < 86400", name: "check_end_seconds"
    t.check_constraint "start_seconds < end_seconds", name: "check_valid_time_range"
    t.check_constraint "start_seconds >= 0 AND start_seconds < 86400", name: "check_start_seconds"
  end

  create_table "bill_rate_customers", force: :cascade do |t|
    t.integer "bill_rate_id"
    t.uuid "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bill_rate_languages", force: :cascade do |t|
    t.integer "bill_rate_id"
    t.integer "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bill_rates", force: :cascade do |t|
    t.uuid "account_id"
    t.string "name"
    t.decimal "hourly_bill_rate", precision: 8, scale: 2
    t.boolean "is_active", default: true
    t.integer "minimum_time_charged"
    t.integer "round_time"
    t.integer "round_increment"
    t.decimal "after_hours_overage", precision: 8, scale: 2
    t.integer "regular_hours_start_seconds"
    t.integer "regular_hours_end_seconds"
    t.decimal "rush_overage", precision: 8, scale: 2
    t.integer "rush_overage_trigger"
    t.decimal "cancel_rate", precision: 8, scale: 2
    t.integer "cancel_rate_trigger"
    t.boolean "default_rate", default: false
    t.boolean "in_person", default: false
    t.boolean "phone", default: false
    t.boolean "video", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billing_line_items", force: :cascade do |t|
    t.integer "appointment_id"
    t.string "type_key"
    t.string "description"
    t.decimal "rate"
    t.decimal "hours"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checklist_items", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "checklist_type_id", null: false
    t.boolean "bool_val"
    t.string "text_val"
    t.date "start_date"
    t.date "exp_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notifications_sent", default: false
    t.index ["checklist_type_id"], name: "index_checklist_items_on_checklist_type_id"
    t.index ["user_id"], name: "index_checklist_items_on_user_id"
  end

  create_table "checklist_types", force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "name"
    t.integer "format"
    t.boolean "is_active", default: true, null: false
    t.boolean "requires_expiration"
    t.boolean "requires_upload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_checklist_types_on_account_id"
  end

  create_table "connected_accounts", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "refresh_token"
    t.datetime "expires_at", precision: nil
    t.text "auth"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "access_token"
    t.string "access_token_secret"
    t.uuid "owner_id"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_connected_accounts_on_owner_id_and_owner_type"
  end

  create_table "customer_agencies", force: :cascade do |t|
    t.uuid "agency_id"
    t.uuid "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_customer_agencies_on_agency_id"
    t.index ["customer_id"], name: "index_customer_agencies_on_customer_id"
  end

  create_table "customer_categories", force: :cascade do |t|
    t.string "display_value"
    t.string "appointment_prefix"
    t.string "telephone_prefix"
    t.string "video_prefix"
    t.bigint "backport_id"
    t.bigint "sort_order"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.index ["backport_id"], name: "index_customer_categories_on_backport_id"
    t.index ["display_value"], name: "index_customer_categories_on_display_value"
  end

  create_table "customer_details", force: :cascade do |t|
    t.string "contact_name"
    t.string "email"
    t.text "notes"
    t.string "phone"
    t.string "fax"
    t.boolean "appointments_in_person", default: true
    t.boolean "appointments_video", default: true
    t.boolean "appointments_phone", default: true
    t.uuid "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_category_id"
    t.index ["customer_category_id"], name: "index_customer_details_on_customer_category_id"
    t.index ["customer_id"], name: "index_customer_details_on_customer_id"
  end

  create_table "customer_requestors", force: :cascade do |t|
    t.uuid "customer_id"
    t.uuid "requestor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "location"
    t.string "accounting_unit_code"
    t.text "accounting_unit_desc"
    t.boolean "is_active", default: true, null: false
    t.uuid "site_id", null: false
    t.integer "backport_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_departments_on_site_id"
  end

  create_table "interpreter_details", force: :cascade do |t|
    t.integer "interpreter_type"
    t.integer "gender"
    t.string "primary_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ssn"
    t.date "dob"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.date "start_date"
    t.string "drivers_license"
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone"
    t.uuid "interpreter_id"
    t.index ["interpreter_id"], name: "index_interpreter_details_on_interpreter_id"
  end

  create_table "interpreter_languages", force: :cascade do |t|
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "interpreter_id"
    t.index ["interpreter_id"], name: "index_interpreter_languages_on_interpreter_id"
    t.index ["language_id"], name: "index_interpreter_languages_on_language_id"
  end

  create_table "interpreter_specialties", force: :cascade do |t|
    t.bigint "specialty_id", null: false
    t.uuid "interpreter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interpreter_id"], name: "index_interpreter_specialties_on_interpreter_id"
    t.index ["specialty_id"], name: "index_interpreter_specialties_on_specialty_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id", null: false
    t.boolean "is_active", default: true
    t.index ["account_id"], name: "index_languages_on_account_id"
  end

  create_table "notification_emails", force: :cascade do |t|
    t.uuid "account_id"
    t.string "email1"
    t.string "email2"
    t.boolean "appointment_created", default: true
    t.boolean "appointment_edited", default: true
    t.boolean "appointment_declined", default: true
    t.boolean "appointment_cancelled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_settings", force: :cascade do |t|
    t.uuid "user_id"
    t.integer "sms", default: 2
    t.boolean "appointment_offered", default: true
    t.boolean "appointment_scheduled", default: true
    t.boolean "appointment_cancelled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "appointment_created", default: true
    t.boolean "appointment_declined", default: true
    t.boolean "interpreter_cancelled", default: true
    t.boolean "appointment_edited", default: true
    t.boolean "appointment_covered", default: true
    t.boolean "appointment_reminder", default: true
    t.string "sms_number"
    t.boolean "checklist_item_expiration", default: true
  end

  create_table "notification_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.string "platform", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_notification_tokens_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type"
    t.jsonb "params"
    t.datetime "read_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "interacted_at", precision: nil
    t.uuid "account_id", null: false
    t.index ["account_id"], name: "index_notifications_on_account_id"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
  end

  create_table "pay_charges", force: :cascade do |t|
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.integer "amount_refunded"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "data"
    t.integer "application_fee_amount"
    t.string "currency"
    t.jsonb "metadata"
    t.integer "subscription_id"
    t.bigint "customer_id"
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.uuid "owner_id"
    t.string "processor"
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "deleted_at"], name: "customer_owner_processor_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id"
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.uuid "owner_id"
    t.string "processor"
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "processor_id"
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_rate_interpreters", force: :cascade do |t|
    t.integer "pay_rate_id"
    t.uuid "interpreter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_rate_languages", force: :cascade do |t|
    t.integer "pay_rate_id"
    t.integer "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_rates", force: :cascade do |t|
    t.uuid "account_id"
    t.string "name"
    t.decimal "hourly_pay_rate", precision: 8, scale: 2
    t.boolean "is_active", default: true
    t.integer "minimum_time_charged"
    t.decimal "after_hours_overage", precision: 8, scale: 2
    t.decimal "rush_overage", precision: 8, scale: 2
    t.decimal "cancel_rate", precision: 8, scale: 2
    t.boolean "default_rate", default: false
    t.boolean "in_person", default: false
    t.boolean "phone", default: false
    t.boolean "video", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_subscriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.jsonb "data"
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.bigint "customer_id"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.boolean "metered"
    t.string "pause_behavior"
    t.datetime "pause_starts_at"
    t.datetime "pause_resumes_at"
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_line_items", force: :cascade do |t|
    t.integer "appointment_id"
    t.string "type_key"
    t.string "description"
    t.decimal "rate"
    t.decimal "hours"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount", default: 0, null: false
    t.string "interval", null: false
    t.jsonb "details", default: {}, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "trial_period_days", default: 0
    t.boolean "hidden"
    t.string "currency"
    t.integer "interval_count", default: 1
    t.string "description"
    t.string "unit_label"
    t.boolean "charge_per_unit"
  end

  create_table "process_batch_appointments", force: :cascade do |t|
    t.integer "process_batch_id"
    t.integer "appointment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "process_batches", force: :cascade do |t|
    t.uuid "account_id"
    t.integer "process_id"
    t.integer "batch_type"
    t.decimal "total"
    t.boolean "is_processed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "email"
    t.string "primary_phone"
    t.boolean "allow_text"
    t.boolean "allow_email"
    t.uuid "site_id"
    t.uuid "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "customer_id", null: false
    t.index ["customer_id"], name: "index_providers_on_customer_id"
    t.index ["department_id"], name: "index_providers_on_department_id"
    t.index ["site_id"], name: "index_providers_on_site_id"
  end

  create_table "rate_criteria", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "type_key", null: false
    t.string "name"
    t.integer "sort_order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.index ["account_id"], name: "index_rate_criteria_on_account_id"
  end

  create_table "recipients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "email"
    t.string "srn"
    t.string "primary_phone"
    t.string "mobile_phone"
    t.boolean "allow_text"
    t.boolean "allow_email"
    t.uuid "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_recipients_on_customer_id"
  end

  create_table "report_customers", force: :cascade do |t|
    t.integer "report_id"
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.uuid "account_id"
    t.integer "report_type"
    t.date "date_begin"
    t.date "date_end"
    t.boolean "in_person"
    t.boolean "phone"
    t.boolean "video"
    t.string "interpreter_type"
    t.integer "customer_category_id"
    t.uuid "site_id"
    t.uuid "department_id"
    t.integer "language_id"
    t.string "fields_to_show"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "customer_id"
    t.uuid "interpreter_id"
  end

  create_table "requested_interpreters", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "appointment_id", null: false
    t.boolean "rejected", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notification_sent", default: false
    t.index ["appointment_id"], name: "index_requested_interpreters_on_appointment_id"
    t.index ["user_id"], name: "index_requested_interpreters_on_user_id"
  end

  create_table "requestor_details", force: :cascade do |t|
    t.boolean "allow_offsite"
    t.boolean "allow_view_docs"
    t.boolean "allow_view_checklist"
    t.string "primary_phone"
    t.string "work_phone"
    t.uuid "customer_id"
    t.uuid "site_id"
    t.uuid "department_id"
    t.uuid "requestor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "requestor_type"
    t.index ["requestor_id"], name: "index_requestor_details_on_requestor_id"
  end

  create_table "sites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "contact_name"
    t.string "email"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.boolean "active", default: true
    t.bigint "backport_id"
    t.text "notes"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "customer_id", null: false
    t.uuid "account_id"
    t.index ["account_id"], name: "index_sites_on_account_id"
    t.index ["backport_id"], name: "index_sites_on_backport_id"
    t.index ["customer_id"], name: "index_sites_on_customer_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.string "name"
    t.string "display_code"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id", null: false
    t.index ["account_id"], name: "index_specialties_on_account_id"
  end

  create_table "time_offs", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string "reason"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.tsrange "date_range"
    t.index ["user_id"], name: "index_time_offs_on_user_id"
    t.check_constraint "start_datetime < end_datetime", name: "check_valid_datetime_range"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.datetime "accepted_terms_at", precision: nil
    t.datetime "accepted_privacy_at", precision: nil
    t.datetime "announcements_read_at", precision: nil
    t.boolean "admin"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "preferred_language"
    t.boolean "otp_required_for_login"
    t.string "otp_secret"
    t.integer "last_otp_timestep"
    t.text "otp_backup_codes"
    t.boolean "agency_admin"
    t.boolean "tokani_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agency_customers", "customer_categories"
  add_foreign_key "agency_details", "accounts", column: "agency_id"
  add_foreign_key "appointment_specialties", "appointments"
  add_foreign_key "appointment_specialties", "specialties"
  add_foreign_key "appointment_statuses", "appointments"
  add_foreign_key "appointments", "departments"
  add_foreign_key "appointments", "languages"
  add_foreign_key "appointments", "providers"
  add_foreign_key "appointments", "recipients"
  add_foreign_key "appointments", "sites"
  add_foreign_key "appointments", "users", column: "requestor_id"
  add_foreign_key "availabilities", "users"
  add_foreign_key "checklist_items", "checklist_types"
  add_foreign_key "checklist_items", "users"
  add_foreign_key "checklist_types", "accounts"
  add_foreign_key "customer_details", "customer_categories"
  add_foreign_key "departments", "sites"
  add_foreign_key "interpreter_languages", "languages"
  add_foreign_key "interpreter_specialties", "specialties"
  add_foreign_key "languages", "accounts"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "providers", "accounts", column: "customer_id"
  add_foreign_key "providers", "departments"
  add_foreign_key "providers", "sites"
  add_foreign_key "recipients", "accounts", column: "customer_id"
  add_foreign_key "requested_interpreters", "appointments"
  add_foreign_key "requested_interpreters", "users"
  add_foreign_key "sites", "accounts"
  add_foreign_key "specialties", "accounts"
  add_foreign_key "time_offs", "users"
end
