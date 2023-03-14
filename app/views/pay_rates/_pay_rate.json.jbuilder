json.extract! pay_rate, :id, :account_id, :name, :hourly_pay_rate, :is_active, :minimum_time_charged, :after_hours_overage, :rush_overage, :cancel_rate, :default_rate, :in_person, :phone, :video, :created_at, :updated_at
json.url pay_rate_url(pay_rate, format: :json)
