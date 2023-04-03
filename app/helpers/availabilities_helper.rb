module AvailabilitiesHelper
  def start_avail(availability)
    interpreter = availability.interpreter
    time = "#{availability.start_hour.to_s.rjust(2, "0")}:#{availability.start_minute.to_s.rjust(2, "0")}"
    Time.find_zone(interpreter.time_zone).parse(time).strftime("%I:%M %p")
  end

  def end_avail(availability)
    interpreter = availability.interpreter
    time = "#{availability.end_hour.to_s.rjust(2, "0")}:#{availability.end_minute.to_s.rjust(2, "0")}"
    Time.find_zone(interpreter.time_zone).parse(time).strftime("%I:%M %p")
  end

  def modalities_pretty(availability)
    availability.modalities.map { |m| m.to_s.titleize }.join(", ").to_s
  end

  def availability_day(week_day)
    Availability::WDAY_MAPPING[week_day].to_s
  end
end
