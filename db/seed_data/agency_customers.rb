Account.where(customer: true).each do |customer|
  agency_id = Account.where(agency: true).sample.id
  AgencyCustomer.create!(
    customer_id: customer.id,
    agency_id: agency_id
  )
  CustomerAgency.create!(
    customer_id: customer.id,
    agency_id: agency_id
  )
end