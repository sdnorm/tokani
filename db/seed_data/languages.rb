languages = [
  "Spanish",
  "Russian"
]

Account.where(agency: true).each do |agency|
  Language.create!(name: languages.sample, is_active: true, account_id: agency.id)
end