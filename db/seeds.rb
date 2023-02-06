# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
# User.create name: "name", email: "email", password: "password", password_confirmation: "password", admin: true, terms_of_service: true

4.times do |user|
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password",
    terms_of_service: true
  )
end

Account.all.each do |account|
  account.update(name: Faker::Company.name, customer: true)
end

Account.first.update(customer: false)

agency_with_things = Account.find_by(customer: false)
agency_owner_id = agency_with_things.owner_id
start_time = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 20)

AccountUser.all.each do |account_user|
  account_user.update(roles: {"admin" => false})
end

AccountUser.where(account_id: agency_with_things.id, user_id: agency_owner_id).update(roles: {"agency_admin" => true})

Language.create!(name: "English", is_active: true, account_id: agency_with_things.id)

100.times do |appointment|
  Appointment.create!(
    agency_id: agency_with_things.id,
    customer_id: Account.where(customer: true).sample.id,
    start_time: start_time,
    finish_time: start_time + 1.hour,
    notes: Faker::Lorem.sentence,
    ref_number: Faker::Invoice.reference,
    language_id: Language.first.id
  )
end

20.times do |site|
  Site.create(
    customer_id: Account.where(customer: true).sample.id,
    account_id: agency_with_things.id,
    name: Faker::University.name
  )
end

Account.where(customer: true).each do |customer|
  AgencyCustomer.create!(
    customer_id: customer.id,
    agency_id: agency_with_things.id
  )
end

Account.where(customer: true).each do |customer|
  CustomerDetail.create!(
    contact_name: Faker::Name.name,
    email: Faker::Internet.email,
    fax: Faker::PhoneNumber.phone_number,
    notes: Faker::Lorem.sentence,
    phone: Faker::PhoneNumber.phone_number,
    appointments_in_person: true,
    appointments_phone: true,
    appointments_video: true,
    customer_id: customer.id
  )
end

Account.where(customer: false).each do |agency|
  RateCriterium.create!(account_id: agency.id, type_key: :sites_departments, name: "Site/Department", sort_order: 0)
  RateCriterium.create!(account_id: agency.id, type_key: :specialty, name: "Specialty", sort_order: 1)
  RateCriterium.create!(account_id: agency.id, type_key: :language, name: "Language", sort_order: 2)
  RateCriterium.create!(account_id: agency.id, type_key: :interpreter_type, name: "Interpreter Type", sort_order: 3)
end

# Super Admin
User.create!(name: "Super Admin", email: "super@admin.com", password: "password", password_confirmation: "password", admin: true, terms_of_service: true)
