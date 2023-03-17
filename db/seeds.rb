# puts "*************** creating Super Admin ***************"
# load "db/seed_data/super_admin.rb"
# puts " "
puts "*************** creating Agencies / with primary contacts as owners and Details ***************"
load "db/seed_data/agencies.rb"
# load "db/seed_data/agency_details.rb"
# load "db/seed_data/agency_addresses.rb"
puts " "
puts "*************** creating Customers, Details, Categories ***************"
load "db/seed_data/customer_categories.rb"
load "db/seed_data/customers.rb"
puts " "
puts "*************** creating Agency Customers & Customer Agnecies ***************"
load "db/seed_data/agency_customers.rb"
puts " "
puts "*************** creating Languages ***************"
load "db/seed_data/languages.rb"
puts " "
puts "*************** creating Sites ***************"
load "db/seed_data/sites.rb"
puts " "
puts "*************** creating Interpreters ***************"
load "db/seed_data/interpreters.rb"
puts " "
# puts "*************** creating Appointments ***************"
# load "db/seed_data/appointments.rb"
# puts " "

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
# user = User.create(
#   name: "Admin User",
#   email: "email@example.org",
#   password: "password",
#   password_confirmation: "password",
#   terms_of_service: true
# )
# Jumpstart.grant_system_admin!(user)

puts "*************** creating Super Admin ***************"
load "db/seed_data/super_admin.rb"
puts " "
