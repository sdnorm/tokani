class ConfigDeterminationService
  attr_accessor :appointment

  def initialize(appointment)
    @appointment = appointment
    @interpreter = appointment.interpreter
    @customer = appointment.agency_customer
  end

  def determine_config
    # There are only two places to look for a Pay/Bill Config:
    # 1. The Interpreter
    # 2. The Agency Customer

    if @interpreter.pay_bill_configs.any?
      # An Interpreter should only ever have ONE Pay/Bill Config
      return @interpreter.pay_bill_configs.first
    end

    if @customer.pay_bill_configs.any?
      # An Agency Customer should only ever have ONE Pay/Bill Config
      return @customer.pay_bill_configs.first
    end

    nil
  end
end
