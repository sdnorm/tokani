30.times do
  user = User.create!(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: "password",
    terms_of_service: true,
    accepted_terms_at: Time.now
  )
  InterpreterDetail.create!(
    interpreter_id: user.id,
    ssn: "1234567890",
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    dob: Faker::Date.between(from: 65.years.ago, to: 18.years.ago),
    drivers_license: "1234567890",
    emergency_contact_name: Faker::Name.name,
    emergency_contact_phone: "1234567890",
    gender: ["male", "female", "non_binary"].sample,
    interpreter_type: ["staff", "independent_contractor", "agency", "volunteer"].sample,
    primary_phone: "1234567890",
    start_date: Faker::Date.between(from: 2.years.ago, to: Date.today),
    state: Faker::Address.state,
    zip: Faker::Address.zip
  )
  AccountUser.create!(account_id: Account.where(agency: true).sample.id, user_id: user.id, roles: {"interpreter" => true})
end
