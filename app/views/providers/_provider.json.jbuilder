json.extract! provider, :id, :last_name, :first_name, :email, :primary_phone, :allow_text, :allow_email, :site_id, :department_id, :customer_id, :created_at, :updated_at
json.url provider_url(provider, format: :json)
