# == Schema Information
#
# Table name: accounts
#
#  id                 :uuid             not null, primary key
#  agency             :boolean
#  customer           :boolean          default(FALSE)
#  domain             :string
#  extra_billing_info :text
#  is_active          :boolean          default(TRUE)
#  name               :string           not null
#  personal           :boolean          default(FALSE)
#  subdomain          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :uuid
#
# Indexes
#
#  index_accounts_on_created_at  (created_at)
#  index_accounts_on_owner_id    (owner_id)
#
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "validates uniqueness of domain" do
    account = accounts(:company).dup
    assert_not account.valid?
    assert_not_empty account.errors[:domain]
  end

  test "can have multiple accounts with nil domain" do
    user = users(:one)
    Account.create!(owner: user, name: "test")
    Account.create!(owner: user, name: "test2")
  end

  test "validates uniqueness of subdomain" do
    account = accounts(:company).dup
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "can have multiple accounts with nil subdomain" do
    user = users(:one)

    Account.create!(owner: user, name: "test")
    Account.create!(owner: user, name: "test2")
  end

  test "validates against reserved domains" do
    account = Account.new(domain: Jumpstart.config.domain)
    assert_not account.valid?
    assert_not_empty account.errors[:domain]
  end

  test "validates against reserved subdomains" do
    subdomain = Account::RESERVED_SUBDOMAINS.first
    account = Account.new(subdomain: subdomain)
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "subdomain format must start with alphanumeric char" do
    account = Account.new(subdomain: "-abcd")
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "subdomain format must end with alphanumeric char" do
    account = Account.new(subdomain: "abcd-")
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "must be at least two characters" do
    account = Account.new(subdomain: "a")
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "can use a mixture of alphanumeric, hyphen, and underscore" do
    [
      "ab",
      "12",
      "a-b",
      "a-9",
      "1-2",
      "1_2",
      "a_3"
    ].each do |subdomain|
      account = Account.new(subdomain: subdomain)
      account.valid?
      assert_empty account.errors[:subdomain]
    end
  end

  # test "personal accounts enabled" do
  #   Jumpstart.config.stub(:personal_accounts, true) do
  #     user = User.create! name: "Test", email: "personalaccounts@example.com", password: "password", password_confirmation: "password", terms_of_service: true
  #     assert user.accounts.first.personal?
  #   end
  # end

  # test "personal accounts disabled" do
  #   Jumpstart.config.stub(:personal_accounts, false) do
  #     user = User.create! name: "Test", email: "nonpersonalaccounts@example.com", password: "password", password_confirmation: "password", terms_of_service: true
  #     assert_not user.accounts.first.personal?
  #   end
  # end

  test "owner?" do
    account = accounts(:one)
    assert account.owner?(users(:one))
    refute account.owner?(users(:two))
  end

  test "can_transfer? false for personal accounts" do
    refute accounts(:one).can_transfer?(users(:one))
  end

  test "can_transfer? true for owner" do
    account = accounts(:company)
    assert account.can_transfer?(account.owner)
  end

  test "can_transfer? false for non-owner" do
    refute accounts(:company).can_transfer?(users(:two))
  end

  # test "transfer ownership to a new owner" do
  #   account = accounts(:company)
  #   new_owner = users(:two)
  #   assert accounts(:company).transfer_ownership(new_owner.id)
  #   assert_equal new_owner, account.reload.owner
  # end

  test "transfer ownership fails transferring to a user outside the account" do
    account = accounts(:company)
    owner = account.owner
    refute account.transfer_ownership(users(:invited).id)
    assert_equal owner, account.reload.owner
  end

  test "billing_email shouldn't be included in receipts if empty" do
    account = accounts(:company)
    account.update!(billing_email: nil)
    pay_customer = account.set_payment_processor :fake_processor, allow_fake: true
    pay_charge = pay_customer.charge(10_00)

    mail = Pay::UserMailer.with(pay_customer: pay_customer, pay_charge: pay_charge).receipt
    assert_equal [account.email], mail.to
  end

  test "billing_email should be included in receipts if present" do
    account = accounts(:company)
    account.update!(billing_email: "accounting@example.com")
    pay_customer = account.set_payment_processor :fake_processor, allow_fake: true
    pay_charge = pay_customer.charge(10_00)

    mail = Pay::UserMailer.with(pay_customer: pay_customer, pay_charge: pay_charge).receipt
    assert_equal [account.email, "accounting@example.com"], mail.to
  end
end
