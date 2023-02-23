4.times do
  agency = Account.create(
    name: Faker::Company.name,
    agency: true
  )
end