class InterpretersController < ApplicationController
  include CurrentHelper

  # before_action :authenticate_user!

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /customers
  def index
    @pagy, @interpreters = pagy(User.where(id: current_account.account_users.interpreter.pluck(:user_id)).sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @interpreters
  end

	def my_scheduled
  end
end
