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
    if appointment.status == "scheduled"
      appointment.interpreter.name
    # NW - commented this out - not sure what it is supposed to be doing - not working 5/1/23
    # "#{appointment.interpreter.name}  #{link_to "view checklist items", interpreter_items_checklist_item_path(@appointment.interpreter)})"
    else
      return "No interpreters requested" if appointment.requested_interpreters.blank?

      appointment.offered_interpreters.map { |interpreter| interpreter.full_name }.to_sentence
    end
  end

  def cancel_button_link(appointment)
    return unless appointment.can_cancel?

    link_to(
      "Cancel", "", class: "inline-flex items-center justify-center rounded-lg border bg-transparent border-red-500 py-2 px-3.5 text-sm font-medium text-red-600 shadow-sm hover:bg-red-500 hover:text-white focus:outline-none",
      data: {
        action: "click->appointments#showReason",
        controller: "appointments",
        do: "cancel"
      }
    )
  end

  def open_button_link(appointment)
    return unless appointment.can_open?

    link_to(
      "Open", update_status_appointment_path(appointment, status: "open"),
      class: "inline-flex items-center justify-center rounded-lg border bg-transparent border-red-500 py-2 px-3.5 text-sm font-medium text-red-600 shadow-sm hover:bg-red-500 hover:text-white focus:outline-none",
      method: :post
    )
  end

  def cancel_reason_dropdown_options
    arr = Appointment.cancel_reason_codes.keys.map(&:titleize)
    duplicated_arr = arr.map { |elem| elem.downcase.gsub(/\s+/, "_") }

    Array.new(arr.length) { |i| [arr[i].titleize, duplicated_arr[i]] }
  end
end
