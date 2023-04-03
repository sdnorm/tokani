json.extract! time_off, :id, :start_datetime, :end_datetime, :reason, :user_id, :created_at, :updated_at
json.url time_off_url(time_off, format: :json)
