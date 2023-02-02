class RateCalculationService
  def initialize(appointment, pay_bill_rate = nil, pay_bill_config = nil)
    @appointment = appointment
    @pay_bill_rate = pay_bill_rate.presence || @appointment.pay_bill_rate
    @pay_bill_config = pay_bill_config.presence || @appointment.pay_bill_config
    @rate_type = nil
  end

  def valid?
    @appointment.present? &&
      @pay_bill_rate.present? &&
      @pay_bill_config.present?
  end

  # Returns a snake-case string interpretation of what rate to pay/bill.
  # Ex: 'regular', 'after_hours', 'rush', 'cancel_level_1'

  def determine_rate_type
    # CHECK FOR CANCELLATION
    case @appointment.cancel_type
    when "requestor"
      # Difference between when the appointment was cancelled and the start time
      cancellation_time_diff = TimeDifference.between(@appointment.start_time, @appointment.cancelled_at).in_hours

      if cancellation_time_diff < @pay_bill_config.trigger_for_cancel_level1
        @rate_type = "cancel_level_1"
        return @rate_type
      elsif cancellation_time_diff < @pay_bill_config.trigger_for_cancel_level2
        @rate_type = "cancel_level_2"
        return @rate_type
      else
        @rate_type = "cancelled_unbillable"
        return @rate_type
      end
    when "agency"
      @rate_type = "cancelled_unbillable"
      return @rate_type
    end

    # CHECK FOR RUSH & AFTER HOURS
    if rush_rate? && after_hours_rate?
      @rate_type = "rush_and_after_hours"
      return @rate_type
    end

    # CHECK FOR RUSH
    if rush_rate?
      @rate_type = "rush"
      return @rate_type
    end

    # CHECK FOR AFTER HOURS
    if after_hours_rate?
      @rate_type = "after_hours"
      return @rate_type
    end

    # If we get here, it must be the default, "regular" rate
    @rate_type = "regular"
    @rate_type
  end

  def discount_rate_triggered?
    @appointment.calculated_appointment_duration_in_hours > @pay_bill_config.trigger_for_discount_rate
  end

  # Use Config billing increment and trigger for billing increment to determine
  # the actual # of billable minutes. EXCLUDE discount rate minutes.
  def calculate_billable_minutes_at_regular_rate
    duration = [@appointment.calculated_appointment_duration_in_hours, @pay_bill_config.trigger_for_discount_rate].min

    # Convert to minutes
    duration = (duration * 60.0).round(0)

    # Run the config billing increment/trigger algorithm on the duration
    calculate_billable_minutes_via_trigger_algorithm(duration)
  end

  def calculate_billable_minutes_at_discount_rate
    return 0 unless discount_rate_triggered?

    diff = @appointment.calculated_appointment_duration_in_hours - @pay_bill_config.trigger_for_discount_rate

    calculate_billable_minutes_via_trigger_algorithm(diff * 60)
  end

  def ensure_pay_bill_config_enforced_minimum_minutes_billed(minutes_value)
    return minutes_value if @pay_bill_config.is_minutes_billed_appointment_duration

    [minutes_value, @pay_bill_config.minimum_minutes_billed].max
  end

  def ensure_pay_bill_config_enforced_minimum_minutes_paid(minutes_value)
    return minutes_value if @pay_bill_config.is_minutes_billed_appointment_duration

    [minutes_value, @pay_bill_config.minimum_minutes_paid].max
  end

  def billing_line_items
    determine_rate_type if @rate_type.blank?

    return [] if cancelled_unbillable?
    return billing_line_items_cancelled if %w[cancel_level_1 cancel_level_2].include?(@rate_type)

    hours = @appointment.calculated_appointment_duration_in_hours
    line_items = []

    # Handle regular rate line item
    billable_minutes_regular = ensure_pay_bill_config_enforced_minimum_minutes_billed(calculate_billable_minutes_at_regular_rate)
    billable_hours_regular = (billable_minutes_regular / 60.0).round(2)
    b = BillingLineItemStruct.new("regular", "Regular billing rate", @pay_bill_rate.bill_rate, billable_hours_regular, @pay_bill_rate.name)
    line_items << b

    if discount_rate_triggered?
      # Handle discount rate line item
      billable_minutes_discount = calculate_billable_minutes_at_discount_rate
      billable_hours_discount = (billable_minutes_discount / 60.0).round(2)

      rate = @pay_bill_rate.bill_rate - @pay_bill_rate.discount_bill_rate
      line_items << BillingLineItemStruct.new("discount", "Discount billing rate", rate, billable_hours_discount, @pay_bill_rate.name)
    end

    # CHECK FOR RUSH
    if rush_rate?
      line_items << BillingLineItemStruct.new("rush", "Rush billing rate", @pay_bill_rate.rush_bill_rate, hours, @pay_bill_rate.name)
    end

    # CHECK FOR AFTER HOURS
    if after_hours_rate?
      line_items << BillingLineItemStruct.new("after_hours", "After hours billing rate", @pay_bill_rate.after_hours_bill_rate, hours, @pay_bill_rate.name)
    end

    line_items
  end

  def billing_line_items_cancelled
    hours = (@appointment.duration / 60.0).round(2)

    case @rate_type
    when "cancel_level_1"
      if @pay_bill_config.is_minutes_billed_cancelled_appointment_duration
        li = BillingLineItemStruct.new("cancel_level_1", "Cancelled Level 1 billing rate (appointment duration)", @pay_bill_rate.cancel_level_1_bill_rate, hours)
      else
        hours = (@pay_bill_config.minimum_minutes_billed_cancelled_level1 / 60.0).round(2)
        li = BillingLineItemStruct.new("cancel_level_1", "Cancelled Level 1 billing rate (configured minimum)", @pay_bill_rate.cancel_level_1_bill_rate, hours)
      end
      return [li]
    when "cancel_level_2"
      if @pay_bill_config.is_minutes_billed_cancelled_appointment_duration
        li = BillingLineItemStruct.new("cancel_level_2", "Cancelled Level 2 billing rate (appointment duration)", @pay_bill_rate.cancel_level_2_bill_rate, hours)
      else
        hours = (@pay_bill_config.minimum_minutes_billed_cancelled_level2 / 60.0).round(2)
        li = BillingLineItemStruct.new("cancel_level_2", "Cancelled Level 2 billing rate (configured minimum)", @pay_bill_rate.cancel_level_2_bill_rate, hours)
      end
      return [li]
    end

    []
  end

  def payment_line_items
    determine_rate_type if @rate_type.blank?

    return [] if cancelled_unbillable?
    return payment_line_items_cancelled if %w[cancel_level_1 cancel_level_2].include?(@rate_type)

    hours = @appointment.calculated_appointment_duration_in_hours
    line_items = []

    billable_minutes_regular = ensure_pay_bill_config_enforced_minimum_minutes_paid(calculate_billable_minutes_at_regular_rate)
    billable_hours_regular = (billable_minutes_regular / 60.0).round(2)
    # Handle regular rate line item
    li = PaymentLineItemStruct.new("regular", "Regular payment rate", @pay_bill_rate.pay_rate, billable_hours_regular, @pay_bill_rate.name)
    line_items << li

    if discount_rate_triggered?
      # Handle discount rate line item
      billable_minutes_discount = calculate_billable_minutes_at_discount_rate
      billable_hours_discount = (billable_minutes_discount / 60.0).round(2)

      rate = @pay_bill_rate.pay_rate - @pay_bill_rate.discount_pay_rate
      line_items << PaymentLineItemStruct.new("discount", "Discount payment rate", rate, billable_hours_discount, @pay_bill_rate.name)
    end

    # CHECK FOR RUSH
    if rush_rate?
      line_items << PaymentLineItemStruct.new("rush", "Rush pay rate", @pay_bill_rate.rush_pay_rate, hours, @pay_bill_rate.name)
    end

    # CHECK FOR AFTER HOURS
    if after_hours_rate?
      line_items << PaymentLineItemStruct.new("after_hours", "After hours payment rate", @pay_bill_rate.after_hours_pay_rate, hours, @pay_bill_rate.name)
    end

    line_items
  end

  def payment_line_items_cancelled
    hours = (@appointment.duration / 60.0).round(2)

    case @rate_type
    when "cancel_level_1"
      if @pay_bill_config.is_minutes_billed_cancelled_appointment_duration
        li = PaymentLineItemStruct.new("cancel_level_1", "Cancelled Level 1 pay rate (appointment duration)", @pay_bill_rate.cancel_level_1_pay_rate, hours)
      else
        hours = (@pay_bill_config.minimum_minutes_paid_cancelled_level1 / 60.0).round(2)
        li = PaymentLineItemStruct.new("cancel_level_1", "Cancelled Level 1 pay rate (configured minimum)", @pay_bill_rate.cancel_level_1_pay_rate, hours)
      end
      return [li]
    when "cancel_level_2"
      if @pay_bill_config.is_minutes_billed_cancelled_appointment_duration
        li = PaymentLineItemStruct.new("cancel_level_2", "Cancelled Level 2 pay rate (appointment duration)", @pay_bill_rate.cancel_level_2_pay_rate, hours)
      else
        hours = (@pay_bill_config.minimum_minutes_paidcancelled_level2 / 60.0).round(2)
        li = BillingLineItemStruct.new("cancel_level_2", "Cancelled Level 2 pay rate (configured minimum)", @pay_bill_rate.cancel_level_2_pay_rate, hours)
      end
      return [li]
    end

    []
  end

  def sum_line_items(line_items)
    return 0.0 if line_items.empty?

    line_items.map(&:total).sum.round(2)
  end

  def total_bill
    sum_line_items(billing_line_items)
  end

  def total_bill_with_expenses
    @expense_items = if @appointment.expense_items.blank?
      []
    else
      @appointment.expense_items
    end
    billing_totals = sum_line_items(billing_line_items)
    expense_totals = @expense_items.map(&:cost).sum.round(2)
    billing_totals + expense_totals
  end

  def total_pay
    sum_line_items(payment_line_items)
  end

  def total_pay_with_expenses
    @expense_items = if @appointment.expense_items.blank?
      []
    else
      @appointment.expense_items
    end
    payment_totals = sum_line_items(payment_line_items)
    expense_totals = @expense_items.map(&:cost).sum.round(2)
    payment_totals + expense_totals
  end

  def rush_rate?
    # Get the difference between when the rate was created and its start time
    diff = TimeDifference.between(@appointment.created_at, @appointment.start_time).in_hours

    (diff < @pay_bill_config.trigger_for_rush_rate)
  end

  def after_hours_rate?
    return after_hours_rate_weekday_start? if @appointment.starts_on_weekday?

    after_hours_rate_weekend_start?
  end

  private

  def canceled_billable?
    %w[cancel_level_1 cancel_level_2].include?(@rate_type)
  end

  def cancelled_unbillable?
    @rate_type == "cancelled_unbillable"
  end

  def calculate_billable_minutes_via_trigger_algorithm(duration_in_minutes)
    return duration_in_minutes if @pay_bill_config.billing_increment.nil? && @pay_bill_config.trigger_for_billing_increment.nil?

    hours = (duration_in_minutes / 60).round
    remainder_minutes = duration_in_minutes % 60
    billing_increment_and_trigger_diff = @pay_bill_config.billing_increment - @pay_bill_config.trigger_for_billing_increment

    billable_minutes = 0

    number_billing_increments = 60 / @pay_bill_config.billing_increment # If Billing increment is 15, would be 4

    billing_increments = []
    1.upto(number_billing_increments) do |x|
      billing_increments << x * @pay_bill_config.billing_increment
    end
    billing_increments.reject! { |j| (j <= 0) || (j > 60) }
    # billing_increments is now an array like: [15, 30, 45, 60]

    billing_increments.each do |increment|
      if remainder_minutes == increment
        billable_minutes = increment
        break
      elsif (increment == billing_increments.last) && (remainder_minutes > increment) && (remainder_minutes > (increment + @pay_bill_config.trigger_for_billing_increment))
        # For the scenarios when we're reaching near the end of the hour
        billable_minutes = [60, increment].max
        break
      elsif remainder_minutes < (increment - billing_increment_and_trigger_diff)
        # Less than the trigger. Billable amount is a billing_increment less than this one
        billable_minutes = [0, (increment - @pay_bill_config.billing_increment)].max
        break
      elsif (remainder_minutes > (increment - @pay_bill_config.trigger_for_billing_increment)) && (remainder_minutes < increment)
        # More than the trigger, but less than the increment. Billable amount is the current increment
        billable_minutes = increment
        break
      end
    end

    (hours * 60) + billable_minutes
  end

  def after_hours_rate_weekday_start?
    appointment_minutes_set = build_appointment_minutes_set

    if @pay_bill_config.afterhours_availability_start_seconds1.present? && @pay_bill_config.afterhours_availability_end_seconds1.present?
      afterhours_1_set = Set.new
      @pay_bill_config.afterhours_availability_start_seconds1.upto(@pay_bill_config.afterhours_availability_end_seconds1).each do |i|
        afterhours_1_set.add(i)
      end

      # Does the appointment minutes set contain any overlapping minutes with the Afterhours 1 set?

      appointment_and_after_hours_union = appointment_minutes_set & afterhours_1_set

      # Check for greater than 1 overlapping element (i.e. exclude on the minute matches)
      return true if appointment_and_after_hours_union.size > 1
    end

    if @pay_bill_config.afterhours_availability_start_seconds2.present? && @pay_bill_config.afterhours_availability_end_seconds2.present?
      afterhours_2_set = Set.new
      @pay_bill_config.afterhours_availability_start_seconds2.upto(@pay_bill_config.afterhours_availability_end_seconds2).each do |i|
        afterhours_2_set.add(i)
      end

      # Does the appointment minutes set contain any overlapping minutes with the Afterhours 2 set?

      appointment_and_after_hours_union = appointment_minutes_set & afterhours_2_set

      # Check for greater than 1 overlapping element (i.e. exclude on the minute matches)
      return true if appointment_and_after_hours_union.size > 1
    end

    # If we get here, assume it is *NOT* an After Hours appointment
    false
  end

  def after_hours_rate_weekend_start?
    appointment_minutes_set = build_appointment_minutes_set

    if @pay_bill_config.weekend_availability_start_seconds1.present? && @pay_bill_config.weekend_availability_end_seconds1.present?
      afterhours_1_set = Set.new
      @pay_bill_config.weekend_availability_start_seconds1.upto(@pay_bill_config.weekend_availability_end_seconds1).each do |i|
        afterhours_1_set.add(i)
      end

      # Does the appointment minutes set contain any overlapping minutes with the Afterhours 1 set?

      appointment_and_after_hours_union = appointment_minutes_set & afterhours_1_set

      # Check for greater than 1 overlapping element (i.e. exclude on the minute matches)
      return true if appointment_and_after_hours_union.size > 1
    end

    if @pay_bill_config.weekend_availability_start_seconds2.present? && @pay_bill_config.weekend_availability_end_seconds2.present?
      afterhours_2_set = Set.new
      @pay_bill_config.weekend_availability_start_seconds2.upto(@pay_bill_config.weekend_availability_end_seconds2).each do |i|
        afterhours_2_set.add(i)
      end

      # Does the appointment minutes set contain any overlapping minutes with the Afterhours 2 set?

      appointment_and_after_hours_union = appointment_minutes_set & afterhours_2_set

      # Check for greater than 1 overlapping element (i.e. exclude on the minute matches)
      return true if appointment_and_after_hours_union.size > 1
    end

    # If we get here, assume it is *NOT* an After Hours appointment
    false
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
end
