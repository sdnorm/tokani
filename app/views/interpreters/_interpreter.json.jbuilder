json.extract! customer, :id, :name, :contact_name, :email, :address, :city, :state, :zip, :is_active, :notes, :fax, :phone, :appointments_in_person, :appointments_video, :appointments_phone, :created_at, :updated_at
json.url customer_url(customer, format: :json)
