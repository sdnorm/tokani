json.extract! site, :id, :name, :contact_name, :email, :address, :city, :state, :zip_code, :active, :backport_id, :notes, :contact_phone, :created_at, :updated_at
json.url site_url(site, format: :json)
