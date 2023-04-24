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
    color_class = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium capitalize "

    color_class += case status
    when "scheduled"
      "bg-green-200 text-green-500"
    when "processed", "finished"
      "bg-blue-200 text-blue-500"
    else
      "bg-gray-100 text-gray-500"
    end

    content_tag :p, class: color_class do
      status
    end
  end

  def appointment_interpreter_by_status(appointment)
    if appointment.status == "Scheduled"
      "#{appointment.interpreter.name} (#{link_to 'view checklist items', interpreter_items_checklist_item_path(@appointment.interpreter)})"
    else
      return "No interpreters requested" if appointment.requested_interpreters.blank?

      appointment.offered_interpreters.map { |interpreter| interpreter.full_name }.to_sentence
    end
  end
end

