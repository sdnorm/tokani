module PayBillConfigsHelper
  def start_config(pay_bill_config, start_column)
    if pay_bill_config.start_hour(start_column).blank?
      time_string = "N/A"
    else
      time = "#{pay_bill_config.start_hour(start_column).to_s.rjust(2, "0")}:#{pay_bill_config.start_minute(start_column).to_s.rjust(2, "0")}"
      time_string = Time.find_zone(Agency.timezone).parse(time).strftime("%I:%M %p")
    end

    time_string
  end

  def end_config(pay_bill_config, end_column)
    if pay_bill_config.end_hour(end_column).blank?
      time_string = "N/A"
    else
      time = "#{pay_bill_config.end_hour(end_column).to_s.rjust(2, "0")}:#{pay_bill_config.end_minute(end_column).to_s.rjust(2, "0")}"
      time_string = Time.find_zone(Agency.timezone).parse(time).strftime("%I:%M %p")
    end
    time_string
  end
end
