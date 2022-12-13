# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
# User.create name: "name", email: "email", password: "password", password_confirmation: "password", admin: true, terms_of_service: true

# Super Admin
User.create!(name: "Super Admin", email: "super@admin.com", password: "password", password_confirmation: "password", admin: true, terms_of_service: true)

10.times do |user|
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password",
    terms_of_service: true,
  )
end

# 3.times do |account|
  Account.create!(
    name: Faker::Company.name,
    owner_id: User.all.sample.id
  )
# end

agency_with_things = Account.where(customer: false, personal: false).first

agency_owner_ids = Account.where(personal: false).pluck(:owner_id)

possible_owner_ids = User.where.not(id: agency_owner_ids).pluck(:id) - agency_owner_ids

3.times do |account|
  Account.create!(
    customer: true,
    name: Faker::Company.name,
    owner_id: possible_owner_ids.pop
  )
end

# Account.where(customer: false, personal: false).each do |agency|
  AccountUser.create!(
    account_id: agency_with_things.id, 
    user_id: agency_with_things.owner_id, 
    roles: {agency_admin: true}
  )
# end

start_time = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 20)

100.times do |appointment|
  Appointment.create!(
    agency_id: Account.where(customer: false, personal: false).sample.id,
    # customer_id: Account.all.sample.id,
    start_time: start_time,
    finish_time: start_time + 1.hour,
    notes: Faker::Lorem.sentence,
    ref_number: Faker::Invoice.reference
  )
end

20.times do |site|
  Site.create(
    customer_id: Account.where(customer: true).sample.id,
    name: Faker::University.name
  )
end

Account.where(customer: true).each do |customer|
  AgencyCustomer.create!(
    customer_id: customer.id,
    agency_id: agency_with_things.id
  )
end
