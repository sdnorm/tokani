json.extract! requestor_detail, :id, :created_at, :updated_at
json.url requestor_detail_url(requestor_detail, format: :json)
