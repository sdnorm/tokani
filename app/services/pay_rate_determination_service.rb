class PayRateDeterminationService
  def initialize(appointment)
    @appointment = appointment
    @account = appointment.agency
    @interpreter = appointment.interpreter
  end

  def determine_pay_rate
    if @interpreter&.pay_rates&.active&.any?
      return @interpreter.pay_rates.active.first
    end

    if @language&.pay_rates&.active&.any?
      return @language.pay_rates.active.first
    end

    default_for_modality
  end

  def default_for_modality
    @account.pay_rates.active.where(default_rate: true).where("pay_rates.#{@appointment.modality} = ?", true).first
  end
end
