Account.all.each do |account|
  account.update(name: Faker::Company.name, customer: true)
end

Account.where(customer: true).each do |customer|
  CustomerDetail.create!(
    contact_name: Faker::Name.name,
    email: Faker::Internet.email,
    fax: Faker::PhoneNumber.phone_number,
    notes: Faker::Lorem.sentence,
    phone: "222-222-2222",
    appointments_in_person: true,
    appointments_phone: true,
    appointments_video: true,
    customer_id: customer.id,
    customer_category_id: CustomerCategory.all.sample.id
  )
  user = User.create!(
    name: customer.customer_detail.contact_name,
    email: customer.customer_detail.email,
    password: SecureRandom.alphanumeric,
    terms_of_service: true,
    accepted_terms_at: Time.current
  )
  customer.update(owner_id: user.id)
  customer.account_users.create!(user: user, roles: {"customer_admin" => true})
end
