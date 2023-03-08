100.times do |appointment|
  start_time = Faker::Time.between(DateTime.now, DateTime.now + 1.hour)
  Appointment.create!(
    agency_id: Account.where(agency: true).sample.id,
    customer_id: Account.where(customer: true).sample.id,
    start_time: start_time,
    finish_time: start_time + 30.minutes,
    notes: Faker::Lorem.sentence,
    ref_number: Faker::Invoice.reference,
    language_id: Language.first.id,
    modality: ["in_person", "phone", "video"].sample
  )
end