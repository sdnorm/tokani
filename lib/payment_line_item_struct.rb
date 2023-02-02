class PaymentLineItemStruct < Struct.new(:type_key, :description, :rate, :hours, :name)

  def total
    return 0 unless rate.present? && hours.present?

    rate * hours
  end

end
