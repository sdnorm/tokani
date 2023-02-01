module ProcessBatchesHelper
  def customer_subtotal(sites_hash)
    total = 0.0
    sites_hash.each do |_, appts|
      total += subtotal_billed_appointments(appts)
    end

    total
  end

  def subtotal_billed_appointments(appointments)
    appointments.inject(0) do |result, element|
      result + (element&.total_billed || 0.0)
    end
  end

  def subtotal_paid_appointments(appointments)
    appointments.inject(0) do |result, element|
      result + element.total_paid
    end
  end
end
