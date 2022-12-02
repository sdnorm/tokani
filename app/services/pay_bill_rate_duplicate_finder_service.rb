class PayBillRateDuplicateFinderService
  attr_accessor :pay_bill_rate

  def initialize(pay_bill_rate)
    @pay_bill_rate = pay_bill_rate
    @matches = []
  end

  def find_duplicates
    fetch_base_matches
    return [] if @matches.empty?

    filter_language_matches
    return [] if @matches.empty?

    filter_specialty_matches
    return [] if @matches.empty?

    filter_interpreter_type_matches
    return [] if @matches.empty?

    filter_customer_matches
    return [] if @matches.empty?

    filter_site_matches
    return [] if @matches.empty?

    filter_department_matches
    return [] if @matches.empty?

    filter_interpreter_matches
    return [] if @matches.empty?

    @matches
  end

  private

  def fetch_base_matches
    @matches = PayBillRate.where.not(id: pay_bill_rate.id)
      .where(in_person: pay_bill_rate.in_person)
      .where(phone: pay_bill_rate.phone)
      .where(video: pay_bill_rate.video)

    @matches = @matches.to_a
  end

  def filter_language_matches
    @matches.select! do |pbr|
      pbr.languages.map(&:id).to_set == pay_bill_rate.languages.map(&:id).to_set
    end
  end

  def filter_specialty_matches
    @matches.select! do |pbr|
      pbr.specialties.map(&:id).to_set == pay_bill_rate.specialties.map(&:id).to_set
    end
  end

  def filter_interpreter_type_matches
    @matches.select! do |pbr|
      pbr.pay_bill_rate_interpreter_types.map(&:interpreter_type).to_set == pay_bill_rate.pay_bill_rate_interpreter_types.map(&:interpreter_type).to_set
    end
  end

  def filter_customer_matches
    @matches.select! do |pbr|
      pbr.agency_customers.map(&:id).to_set == pay_bill_rate.agency_customers.map(&:id).to_set
    end
  end

  def filter_site_matches
    @matches.select! do |pbr|
      pbr.sites.map(&:id).to_set == pay_bill_rate.sites.map(&:id).to_set
    end
  end

  def filter_department_matches
    @matches.select! do |pbr|
      pbr.departments.map(&:id).to_set == pay_bill_rate.departments.map(&:id).to_set
    end
  end

  def filter_interpreter_matches
    @matches.select! do |pbr|
      pbr.interpreters.map(&:id).to_set == pay_bill_rate.interpreters.map(&:id).to_set
    end
  end
end
