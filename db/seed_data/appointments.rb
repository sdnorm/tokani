agency = Account.find_by(name: "Agency4000")
customer = Account.find_by(name: "Westside Hospital")
# interpreter = User.find_by(email: "joe@thebestinterpreter.com")
# department =
# site = Site.find_by(name: "Site")
site = customer.sites.first
requestor = customer.owner
modalities = ["in_person", "phone", "video"]
language = Language.find(3)

# 20.times do
#   Appointment.create!(
#     agency_id: agency.id,
#     customer_id: customer.id,
#     site_id: site.id,
#     start_time: Time.now + rand(1..10).days,
#     duration: rand(15..90).minutes,
#     modality: modalities.sample,
#     language_id: language.id,
#     requestor_id: requestor.id,
#     interpreter_req_ids: [interpreter.id],
#     creator_id: agency.owner.id,
#   )
# end

20.times do
  Appointment.create!(
    agency_id: agency.id,
    customer_id: customer.id,
    site_id: site.id,
    start_time: Time.now + rand(1..10).days,
    duration: rand(15..90).minutes,
    modality: modalities.sample,
    language_id: language.id,
    requestor_id: requestor.id,
    creator_id: agency.owner.id
  )
end
