module RequestorDetailsHelper
  def requestor_type_options
    RequestorDetail.requestor_types.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def get_customer(req_details)
    cust_name = Customer.find(req_details.customer_id)
    cust_name.name
  end
end
