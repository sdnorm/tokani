json.extract! recipient, :id, :last_name, :first_name, :email, :srn, :primary_phone, :mobile_phone, :allow_text, :allow_email, :customer_id, :created_at, :updated_at
json.url recipient_url(recipient, format: :json)
