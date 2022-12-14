class CustomersController < ApplicationController
  def index
    @pagy, @customers = pagy(current_account.customers.sort_by_params(params[:sort], sort_direction))
  end

  def show
  end
end
