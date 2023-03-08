25.times do
  Account.create!(
    name: Faker::Company.name,
    agency: true
  )
end

Agency.where(agency: true).each do |agency|
  agency.addresses.create!(
    # addressable_id: agency.id,
    address_type: "physical",
    line1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    postal_code: Faker::Address.zip
  )

  # Address.create(
  #   line1: Faker::Address.street_address,
  #   city: Faker::Address.city,
  #   state: Faker::Address.state,
  #   postal_code: Faker::Address.zip_code,
  #   address_type: "physical",
  #   addressable_id: agency.id
  # )
  AgencyDetail.create!(
    agency_id: agency.id,
    company_website: Faker::Internet.url,
    phone_number: "222-222-2222",
    primary_contact_email: Faker::Internet.email,
    primary_contact_first_name: Faker::Name.first_name,
    primary_contact_last_name: Faker::Name.last_name,
    primary_contact_phone_number: "222-222-2222",
    primary_contact_title: Faker::Job.title,
    url: agency.name.parameterize,
  )
  user = User.create!(
    email: agency.agency_detail.primary_contact_email,
    password: SecureRandom.alphanumeric,
    first_name: agency.agency_detail.primary_contact_first_name,
    last_name: agency.agency_detail.primary_contact_last_name,
    terms_of_service: true,
    accepted_terms_at: Time.current
  )
  agency.update!(owner_id: user.id)
  agency.account_users.create!(user: user, roles: {"agency_admin" => true})
end

Account.where(agency: true).each do |agency|
  RateCriterium.create!(account_id: agency.id, type_key: :sites_departments, name: "Site/Department", sort_order: 0)
  RateCriterium.create!(account_id: agency.id, type_key: :specialty, name: "Specialty", sort_order: 1)
  RateCriterium.create!(account_id: agency.id, type_key: :language, name: "Language", sort_order: 2)
  RateCriterium.create!(account_id: agency.id, type_key: :interpreter_type, name: "Interpreter Type", sort_order: 3)
end