class AgencyCustomerCreationMailer < ApplicationMailer
  helper :application
  include Devise::Controllers::UrlHelpers

  def welcome(user, customer)
    create_reset_password_token(user)
    @user = user
    @customer = customer
    mail(to: user.email, subject: "Welcome to Tokani!")
  end

  private

  def create_reset_password_token(user)
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @token = raw
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save
  end
end
