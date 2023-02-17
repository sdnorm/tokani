module InterpretersHelper
  def appointment_readable_link_title(appt, user)
    return "(not found)" unless appt.present?
    start_time = appt&.start_time_in_zone(user.time_zone)
    ord = start_time.day.ordinal
    [appt.ref_number, appt&.customer&.name, start_time&.strftime("%B %-d#{ord} at %l:%M %P")].compact.join(" - ")
  end
end
