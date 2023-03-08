20.times do |site|
  Site.create(
    customer_id: Account.where(customer: true).sample.id,
    account_id: Account.where(agency: true).sample.id,
    name: Faker::University.name
  )
end
