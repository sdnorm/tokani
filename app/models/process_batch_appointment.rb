# == Schema Information
#
# Table name: process_batch_appointments
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  appointment_id   :integer
#  process_batch_id :integer
#
class ProcessBatchAppointment < ApplicationRecord
  belongs_to :process_batch
  belongs_to :appointment
end
