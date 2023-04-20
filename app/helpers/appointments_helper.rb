module AppointmentsHelper
  def gender_req_options
    Appointment.gender_reqs.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def appt_modality_options
    Appointment.modalities.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def viewable_filter_options
    [
      %w[Everyone all],
      ["Only Admin Staff", "admin"],
      ["Only Agency Interpreters", "agency"],
      ["Only Staff Interpreters", "staff"],
      ["Only Volunteer Interpreters", "volunteer"],
      ["Only Independent Contractors", "independent_contractor"],
      %w[None none]
    ]
  end

  def colored_appointment_status(status)
    color_class = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 capitalize "
    color_class += (status == "scheduled") ? "text-green-500" : "text-gray-500"

    content_tag :p, class: color_class do
      status
    end
  end
end
