Account.all.each do |agency|
  AgencyDetail.create(
    primary_contact_first_name: Faker::Name.first_name,
    primary_contact_last_name: Faker::Name.last_name,
    primary_contact_email: Faker::Internet.email,
    primary_contact_title: Faker::Job.title,
    secondary_contact_first_name: Faker::Name.first_name,
    secondary_contact_last_name: Faker::Name.last_name,
    secondary_contact_email: Faker::Internet.email,
    secondary_contact_title: Faker::Job.title,
    phone_number: Faker::PhoneNumber.cell_phone,
    url: Faker::Internet.url,
    time_zones: ["(GMT-08:00) Pacific Time (US & Canada)", "(GMT-07:00) Mountain Time (US & Canada)"],
    agency_id: agency.id
  )
end