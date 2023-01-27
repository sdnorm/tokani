class ProcessBatchAppointment < ApplicationRecord
  belongs_to :process_batch
  belongs_to :appointment
end
