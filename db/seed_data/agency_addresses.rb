Account.all.each do |agency|
  Address.create(
    line1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    postal_code: Faker::Address.zip_code,
    address_type: "physical",
    addressable_id: agency.id
  )
end
