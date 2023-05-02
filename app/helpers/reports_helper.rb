module ReportsHelper
  def financial_report_options
    [["Select the Financial Report You Want", ""],
      ["Financial Report", "financial"],
      ["Fill Rate Report", "fill-rate"]]
  end

  def reportable_fields
    {"appt-number" => "Appointment Number",
     "date-of-service" => "Date of Service",
     "time-of-service" => "Time of Service",
     "customer-name" => "Customer Name",
     "site" => "Site",
     "department" => "Department",
     "requestor-name" => "Requestor Name",
     "interpreter-name" => "Interpreter Name",
     "language" => "Language",
     "modality" => "Modality",
     "duration" => "Duration",
     "datetime-start" => "Date/Time Start",
     "datetime-end" => "Date/Time End",
     "actual-duration" => "Actual Hours (Time End - Time Start)",
     "amount-paid" => "Amount Paid (interpreting hours)",
     "amount-billed" => "Amount Billed",
     # "mileage-paid" => "Mileage Paid",
     # "mileage-billed" => "Mileage Billed",
     # "total-paid" => "Total Paid",
     # "total-billed" => "Total Billed",
     "profit-margin" => "Profit Margin"}
  end

  def fill_rate_reportable_fields
    {"customer-name" => "Customer Name",
     "language" => "Language",
     # "interpreter-name" => "Interpreter",
     "appointments-total" => "Total # of Appointments",
     "cancels-total" => "Total # of Client Cancellations",
     "net-requests" => "Net Requests (total appointments - total cancels)",
     "filled-total" => "Filled Total (net requests assigned an interpreter)",
     "not-filled-total" => "Total Not Filled (net requests not assigned an interpreter)",
     "percentage-filled" => "Percentage Filled"}
  end

  def interperter_type_options
    keys = Appointment.interpreter_type_filters.keys
    keys.map { |k| [k.titleize, k] }
  end

  def fill_rate_report_type_options
    [["Please Select a Type of Fill Rate Report", ""],
      ["Customer", "customer"],
      ["Interpreter", "interpreter"],
      ["Language", "language"]]
  end
end
