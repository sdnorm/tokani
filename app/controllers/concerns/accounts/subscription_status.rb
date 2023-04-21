module Accounts
  module SubscriptionStatus
    extend ActiveSupport::Concern

    included do
      helper_method :subscribed?
      helper_method :not_subscribed?
    end

    def subscribed?(name: Pay.default_product_name)
      user_signed_in? && current_account.payment_processor&.subscribed?(name: name)
    end

    def not_subscribed?(name: Pay.default_product_name)
      !subscribed?(name: name)
    end

    def require_subscription!
      # return if Rails.env.development?
      return if subscribed?

      redirect_to pricing_path, notice: "Subscribe now to get access to our features!"
    end
  end
end
