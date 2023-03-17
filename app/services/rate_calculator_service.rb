class RateCalculatorService
  def initialize(appointment, bill_rate = nil, pay_rate = nil)
    @appointment = appointment
    @bill_rate = bill_rate.presence || @appointment.bill_rate
    @pay_rate = pay_rate.presence || @appointment.pay_rate
    @rate_type = nil
  end

  def valid?
    @appointment.present? &&
      @bill_rate.present? &&
      @pay_rate.present?
  end

  def determine_rate_type
    # CHECK FOR CANCELLATION
    case @appointment.cancel_type
    when "requestor"
      # Difference between when the appointment was cancelled and the start time
      cancellation_time_diff = TimeDifference.between(@appointment.start_time, @appointment.cancelled_at).in_hours

      @rate_type = if cancellation_time_diff < @bill_rate.cancel_rate_trigger
        "cancelled"
      else
        "cancelled_unbillable"
      end
      return @rate_type
    when "agency"
      @rate_type = "cancelled_unbillable"
      return @rate_type
    end

    # If we get here, it's just a regular (possibly rush and/or after hours too) rate
    @rate_type = "regular"

    @rate_type
  end

  def billing_line_items
    determine_rate_type if @rate_type.blank?

    return [] if cancelled_unbillable?
    return billing_line_items_cancelled if @rate_type == "cancelled"

    line_items = []

    billable_minutes = round_appointment_duration(@appointment.calculated_appointment_duration_in_minutes)
    billable_minutes = ensure_minimum_duration(billable_minutes)
    billable_hours = (billable_minutes / 60.0).round(2)

    line_items << BillingLineItemStruct.new("regular", "Regular billing rate", @bill_rate.hourly_bill_rate, billable_hours, @bill_rate.name)

    # CHECK FOR RUSH
    if rush_rate?
      line_items << BillingLineItemStruct.new("rush", "Rush billing rate", @bill_rate.rush_overage, billable_hours, @bill_rate.name)
    end

    # CHECK FOR AFTER HOURS
    if after_hours_rate?
      line_items << BillingLineItemStruct.new("after_hours", "After hours billing rate", @bill_rate.after_hours_overage, billable_hours, @bill_rate.name)
    end

    line_items
  end

  def billing_line_items_cancelled
    hours = (@appointment.duration / 60.0).round(2)
    li = BillingLineItemStruct.new("cancelled", "Cancelled billing rate (appointment duration)", @bill_rate.cancel_rate, hours, @bill_rate.name)
    [li]
  end

  def payment_line_items
    determine_rate_type if @rate_type.blank?

    return [] if cancelled_unbillable?
    return payment_line_items_cancelled if @rate_type == "cancelled"

    line_items = []

    billable_minutes = round_appointment_duration(@appointment.calculated_appointment_duration_in_minutes)
    billable_minutes = ensure_minimum_duration(billable_minutes)
    billable_hours = (billable_minutes / 60.0).round(2)

    line_items << PaymentLineItemStruct.new("regular", "Regular payment rate", @pay_rate.hourly_pay_rate, billable_hours, @pay_rate.name)

    # CHECK FOR RUSH
    if rush_rate?
      line_items << PaymentLineItemStruct.new("rush", "Rush payment rate", @pay_rate.rush_overage, billable_hours, @pay_rate.name)
    end

    # CHECK FOR AFTER HOURS
    if after_hours_rate?
      line_items << PaymentLineItemStruct.new("after_hours", "After hours payment rate", @pay_rate.after_hours_overage, billable_hours, @pay_rate.name)
    end

    line_items
  end

  def payment_line_items_cancelled
    hours = (@appointment.duration / 60.0).round(2)
    li = PaymentLineItemStruct.new("cancelled", "Cancelled payment rate (appointment duration)", @pay_rate.cancel_rate, hours, @pay_rate.name)
    [li]
  end

  def total_bill
    sum_line_items(billing_line_items)
  end

  def total_pay
    sum_line_items(payment_line_items)
  end

  def cancelled_unbillable?
    @rate_type == "cancelled_unbillable"
  end

  def after_hours_rate?
    # These values are the offset in seconds from the beginning of the day
    if @bill_rate.after_hours_start_time.present? && @bill_rate.after_hours_end_time.present?

      after_hours_set = Set.new

      0.upto(@bill_rate.after_hours_start_time) do |i|
        after_hours_set.add(i)
      end

      # There are 86400 seconds in the day
      @bill_rate.after_hours_end_time.upto(86400) do |i|
        after_hours_set.add(i)
      end

      # Does the appointment minutes set contain any overalapping minutes with the After Hours set?
      union = build_appointment_minutes_set & after_hour_set

      # Check for greater than 1 overlapping element (i.e. exclude on the minute matches)
      return true if union.size > 1
    end

    # If we get here, assume it is *NOT* an After Hours appointment
    false
  end

  def rush_rate?
    # Get the difference between when the rate was created and its start time
    diff = TimeDifference.between(@appointment.created_at, @appointment.start_time).in_hours

    (diff < @bill_rate.overage_trigger)
  end

  private

  def sum_line_items(line_items)
    return 0.0 if line_items.empty?

    line_items.map(&:total).sum.round(2)
  end

  def build_appointment_minutes_set
    beginning_of_day = @appointment.start_time_with_zone.beginning_of_day
    appointment_start_time_number_seconds_since_beginning_of_day = TimeDifference.between(beginning_of_day, @appointment.start_time_with_zone).in_seconds.round
    appointment_finish_time_number_seconds_since_beginning_of_day = TimeDifference.between(beginning_of_day, @appointment.finish_time_with_zone).in_seconds.round

    appointment_minutes_set = Set.new
    appointment_start_time_number_seconds_since_beginning_of_day.upto(appointment_finish_time_number_seconds_since_beginning_of_day).each do |i|
      appointment_minutes_set.add(i)
    end

    appointment_minutes_set
  end

  # Accepts a duration in minutes and applies the rounding rules to it
  def round_appointment_duration(duration_in_minutes)
    duration_in_minutes = duration_in_minutes.round(0)

    # Get the remainder after diving by 60
    # minutes_portion = duration_in_minutes % 60

    # Use the rounding gem to calculate the ceil/floor/nearest
    case @bill_rate.round_time
    when "round_up"
      duration_in_minutes.ceil_to(@bill_rate.round_increment)
    when "round_down"
      duration_in_minutes.floor_to(@bill_rate.round_increment)
    when "round_closest"
      duration_in_minutes.round_to(@bill_rate.round_increment)
    end
  end

  def ensure_minimum_duration(duration_in_minutes)
    (duration_in_minutes < @bill_rate.minimum_time_charged) ? @bill_rate.minimum_time_charged : duration_in_minutes
  end
end
