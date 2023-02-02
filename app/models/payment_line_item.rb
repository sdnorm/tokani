# == Schema Information
#
# Table name: payment_line_items
#
#  id             :bigint           not null, primary key
#  amount         :decimal(, )
#  description    :string
#  hours          :decimal(, )
#  rate           :decimal(, )
#  type_key       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :integer
#
class PaymentLineItem < ApplicationRecord
  belongs_to :appointment

  def self.persist_from_struct(appointment, line_items)
    line_items.each do |li|
      PaymentLineItem.create!(appointment: appointment,
        type_key: li.type_key,
        description: li.description,
        rate: li.rate,
        hours: li.hours,
        amount: li.total)
    end
  end
end
