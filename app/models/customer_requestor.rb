
class CustomerRequestor < ApplicationRecord
    belongs_to :customer, class_name: "Account", foreign_key: :customer_id
    belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
    
  end
  