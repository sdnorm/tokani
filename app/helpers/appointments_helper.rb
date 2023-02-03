module AppointmentsHelper
  def gender_req_options
    Appointment.gender_reqs.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def appt_modality_options
    Appointment.modalities.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end
end
