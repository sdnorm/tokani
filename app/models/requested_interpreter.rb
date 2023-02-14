class RequestedInterpreter < ApplicationRecord

    belongs_to :interpreter, class_name: "User", foreign_key: 'user_id'
    belongs_to :appointment
  
    enum status: {accepted: 1, rejected: 2, pending: 0}
  
  end