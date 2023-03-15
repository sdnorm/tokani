class CreateInvitedUserAccountJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    User.find(user_id).create_account_user
  end
end
