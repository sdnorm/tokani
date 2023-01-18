module RequestorDetailsHelper
  def requestor_type_options
    RequestorDetail.requestor_types.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def get_customer(req_details)
    cust_name = Customer.find(req_details.customer_id)
    cust_name.name
  end

  def get_site(req_details)
    if req_details.site_id
      site_name = Site.find(req_details.site_id)
      site_name.name
    end
  end

  def get_department(req_details)
    if req_details.department_id
      dept_name = Department.find(req_details.department_id)
      dept_name.name
    end
  end
end
