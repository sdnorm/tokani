4.times do
  Account.create(
    name: Faker::Company.name,
    agency: true
  )
end
