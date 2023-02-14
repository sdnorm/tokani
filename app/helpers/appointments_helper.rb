module AppointmentsHelper
  def gender_req_options
    Appointment.gender_reqs.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def appt_modality_options
    Appointment.modalities.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def interpreter_filter_options
    return [
      %w[Everyone all],
      ['Only Admin Staff', 'admin'],
      ['Only Agency Interpreters', 'agency'],
      ['Only Staff Interpreters', 'staff'],
      ['Only Volunteer Interpreters', 'volunteer'],
      ['Only Independent Contractors', 'independent_contractor'],
      %w[None none]
    ]
  end
end
