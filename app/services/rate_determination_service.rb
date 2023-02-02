class RateDeterminationService
  attr_accessor :appointment

  def initialize(appointment)
    @account = appointment.agency
    @appointment = appointment
    @interpreter = appointment.interpreter
    @rate_criteria = @account.rate_criteria.sorted
    @customer = appointment.customer
  end

  def determine_rate
    # First look for a rate in a matching Rate Category
    # Category Priority Order:
    # 1. Interpreter Rate
    # 2. Customer Rate
    # 3. Agency Rate
    # 4. Default Rate

    pay_bill_rate = nil

    # 1 - Interpreter Rate
    if @interpreter.present? && @interpreter.pay_bill_rates.any?
      # Interpreter should always be present at point of rate determination, check just in case
      # filter @interpreter.pay_bill_rates to only include modality matches for the appointment and pass those rates
      filtered = filter_by_modality(@interpreter.pay_bill_rates.active)
      pay_bill_rate = determine_rate_via_criteria(filtered)
      return pay_bill_rate if pay_bill_rate.present?
    end

    # 2 - Customer Rate
    if @customer.present? && @customer.pay_bill_rates.any?
      pay_bill_rate = determine_rate_via_criteria(filter_by_modality(@customer.pay_bill_rates.active))
      return pay_bill_rate if pay_bill_rate.present?
    end

    # 3 - Agency Rate (NON-Default)
    non_default_pay_bill_rates = PayBillRate.active.non_default
    if non_default_pay_bill_rates.any?
      pay_bill_rate = determine_rate_via_criteria(filter_by_modality(non_default_pay_bill_rates))
      return pay_bill_rate if pay_bill_rate.present?
    end

    # 4 - Agency Default Rates
    default_pay_bill_rates = PayBillRate.active.default
    if default_pay_bill_rates.any?
      pay_bill_rate = determine_rate_via_criteria(filter_by_modality(default_pay_bill_rates))
      return pay_bill_rate if pay_bill_rate.present?
    end

    default_rate(default_pay_bill_rates)
  end

  def determine_rate_via_criteria(pay_bill_rates)
    # puts "Determining Rate via Criteria - Pay Bill Rates: #{pay_bill_rates.inspect}"

    @rate_criteria.each do |criterium|
      # puts "\tDetermining Rate via Criterium: #{criterium.inspect}"

      # Loop through each pay_bill_rates by Criteria type. Filter out ones that don't match
      # Department, for example. If there is only one left, return that rate. If there are still
      # multiple matches, filter by Site, and so on. If there is ever just one rate match left,
      # return it. If we somehow get through all the criteria and there are still multiple matches,
      # return one based on effective date (most recent).

      case criterium.type_key
      when "sites_departments"

        # Use the size of the matches array to determine the match count
        matches = []

        # Is there a match for this Rate to a Department?
        pay_bill_rates.each do |pay_bill_rate|
          # Check Department Match
          next if @appointment.department.blank?

          pbr_departments = pay_bill_rate.departments
          matches << pay_bill_rate if pbr_departments.include?(@appointment.department)
        end

        # Match count scenarios:
        # 0 (Zero)         - NO matches were found. Do nothing. Leave pay_bill_rates as is and continue searching for a match.
        # 1 (One)          - ONE match - we found a match at the highest priority criteria thus far, return it.
        # 2 or More (Two+) - TWO or MORE matches - reset pay_bill_rates to the matches and continue the search.

        return matches.first if matches.size == 1

        pay_bill_rates = matches if matches.size > 1

        # Reset matches
        matches = []

        # Is there a match for this Rate to a Site?
        pay_bill_rates.each do |pay_bill_rate|
          # Check Site Match
          next if @appointment.site.blank?

          pbr_sites = pay_bill_rate.sites
          matches << pay_bill_rate if pbr_sites.include?(@appointment.site)
        end

        return matches.first if matches.size == 1

        pay_bill_rates = matches if matches.size > 1

      when "specialty"
        next if @appointment.specialties.blank?

        matches = []

        # Is there an EXACT match for any of these rates to the appointment Specialties?
        pay_bill_rates.each do |pay_bill_rate|
          # Check EXACT Specialty Match
          #
          # An appointment can have multiple specialties. A Pay/Bill Rate can have multiple specialties.
          # Find exact matches first (e.g. A & B, A & B).
          pbr_specialties = pay_bill_rate.specialties
          matches << pay_bill_rate if pbr_specialties.map(&:id).to_set == @appointment.specialties.map(&:id).to_set
        end

        return matches.first if matches.size == 1

        # NO exact match, check for partial matches. Ex: Pay/Bill Rate has OBGYN but not Spanish Certified.
        pay_bill_rates = matches if matches.size > 1

        matches = []

        # Is there a PARTIAL match for any of these rates to the appointment Specialties?
        pay_bill_rates.each do |pay_bill_rate|
          # Check PARTIAL Specialty Match
          pbr_specialties = pay_bill_rate.specialties
          # Take the UNION of both arrays of IDs. If NOT empty, there's an overlapping specialty.
          matches << pay_bill_rate unless (pbr_specialties.map(&:id) & @appointment.specialties.map(&:id)).empty?
        end

        return matches.first if matches.size == 1

        pay_bill_rates = matches if matches.size > 1

      when "language"
        # Bail early if the appointment somehow does not have a language present
        next if @appointment.language.blank?

        matches = []

        # Is there a match for any of these rates to a Language?
        pay_bill_rates.each do |pay_bill_rate|
          # Check Lnaguage Match
          pbr_languages = pay_bill_rate.languages
          matches << pay_bill_rate if pbr_languages.include?(@appointment.language)
        end

        return matches.first if matches.size == 1

        pay_bill_rates = matches if matches.size > 1

      when "interpreter_type"
        next if @interpreter.blank?

        # Gets a value like 2, as opposed to 'independent_contractor'
        interpreter_type = @interpreter.interpreter_type_before_type_cast

        next if interpreter_type.blank?

        matches = []

        # Is there a match for any of these rates to an Interpreter Type?
        pay_bill_rates.each do |pay_bill_rate|
          # Check Interpreter Type Match
          pbr_interpreter_types = pay_bill_rate.pay_bill_rate_interpreter_types.map(&:interpreter_type)
          matches << pay_bill_rate if pbr_interpreter_types.include?(interpreter_type)
        end

        return matches.first if matches.size == 1

        pay_bill_rates = matches if matches.size > 1

      end
    end

    default_rate(pay_bill_rates)
  end

  private

  def filter_by_modality(pay_bill_rates)
    pay_bill_rates.select do |pbr|
      case @appointment.modality
      when "in_person"
        pbr.in_person
      when "phone"
        pbr.phone
      when "video"
        pbr.video
      end
    end
  end

  def default_rate(rates)
    rates.max_by(&:effective_date)
  end
end
