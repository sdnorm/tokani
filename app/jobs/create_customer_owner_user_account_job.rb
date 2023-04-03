class CreateCustomerOwnerUserAccountJob < ApplicationJob
  queue_as :default

  def perform(customer_id)
    Customer.find(customer_id).create_user_and_owner
  end
end
