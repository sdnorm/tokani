class BillRateDeterminationService
  def initialize(appointment)
    @appointment = appointment
    @account = appointment.agency
    @customer = appointment.customer.becomes(Customer)
    @language = appointment.language
  end

  def determine_bill_rate
    if @customer.bill_rates.active.any?
      return @customer.bill_rates.active.first
    end

    if @language.bill_rates.active.any?
      return @language.bill_rates.active.first
    end

    default_for_modality
  end

  def default_for_modality
    @account.bill_rates.active.where(default_rate: true).where("bill_rates.#{@appointment.modality} = ?", true).first
  end
end
