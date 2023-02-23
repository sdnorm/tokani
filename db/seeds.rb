puts "*************** creating Agencies / with primary contacts as owners ***************"

load "db/seed_data/agencies.rb"
load "db/seed_data/agency_details.rb"

Agency.where(agency: true).each do |agency|
  agency.create_owner_account_from_primary_contact
end

load "db/seed_data/agency_addresses.rb"

puts "*************** created Agencies with agency details and agency adresses ***************"

load "db/seed_data/super_admin.rb"

# puts "*************** creating Customer Categories ***************"

# puts "*************** creating Accounts ***************"

# Account.all.each do |account|
#   account.update(name: Faker::Company.name, customer: true)
# end

# Account.first.update(customer: false)

# agency_with_things = Account.find_by(customer: false)
# agency_owner_id = agency_with_things.owner_id
# start_time = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 20)

# puts "*************** creating Account Users ***************"

# AccountUser.all.each do |account_user|
#   account_user.update(roles: {"admin" => false})
# end

# AccountUser.where(account_id: agency_with_things.id, user_id: agency_owner_id).update(roles: {"agency_admin" => true})

# puts "*************** creating Language ***************"

# Language.create!(name: "English", is_active: true, account_id: agency_with_things.id)

# puts "*************** creating Customer Details ***************"

# Account.where(customer: true).each do |customer|
#   CustomerDetail.create!(
#     contact_name: Faker::Name.name,
#     email: Faker::Internet.email,
#     fax: Faker::PhoneNumber.phone_number,
#     notes: Faker::Lorem.sentence,
#     phone: Faker::PhoneNumber.phone_number,
#     appointments_in_person: true,
#     appointments_phone: true,
#     appointments_video: true,
#     customer_id: customer.id,
#     customer_category_id: CustomerCategory.all.sample.id
#   )
# end

# puts "*************** creating Appointments ***************"

# 100.times do |appointment|
#   Appointment.create!(
#     agency_id: agency_with_things.id,
#     customer_id: Account.where(customer: true).sample.id,
#     start_time: start_time,
#     finish_time: start_time + 1.hour,
#     notes: Faker::Lorem.sentence,
#     ref_number: Faker::Invoice.reference,
#     language_id: Language.first.id,
#     modality: ["in_person", "phone", "video"].sample
#   )
# end

# puts "*************** creating Sites ***************"

# 20.times do |site|
#   Site.create(
#     customer_id: Account.where(customer: true).sample.id,
#     account_id: agency_with_things.id,
#     name: Faker::University.name
#   )
# end

# puts "*************** creating Agency Customers ***************"

# Account.where(customer: true).each do |customer|
#   AgencyCustomer.create!(
#     customer_id: customer.id,
#     agency_id: agency_with_things.id
#   )
# end

# Account.where(agency: true).each do |agency|
#   RateCriterium.create!(account_id: agency.id, type_key: :sites_departments, name: "Site/Department", sort_order: 0)
#   RateCriterium.create!(account_id: agency.id, type_key: :specialty, name: "Specialty", sort_order: 1)
#   RateCriterium.create!(account_id: agency.id, type_key: :language, name: "Language", sort_order: 2)
#   RateCriterium.create!(account_id: agency.id, type_key: :interpreter_type, name: "Interpreter Type", sort_order: 3)
# end
