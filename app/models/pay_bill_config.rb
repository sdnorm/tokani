# == Schema Information
#
# Table name: pay_bill_configs
#
#  id                                               :bigint           not null, primary key
#  afterhours_availability_end_seconds1             :integer
#  afterhours_availability_end_seconds2             :integer
#  afterhours_availability_start_seconds1           :integer
#  afterhours_availability_start_seconds2           :integer
#  billing_increment                                :integer
#  fixed_roundtrip_mileage                          :integer
#  is_active                                        :boolean          default(TRUE)
#  is_minutes_billed_appointment_duration           :boolean          default(FALSE)
#  is_minutes_billed_cancelled_appointment_duration :boolean          default(FALSE)
#  maximum_mileage                                  :integer
#  maximum_travel_time                              :integer
#  minimum_minutes_billed                           :integer
#  minimum_minutes_billed_cancelled_level_1         :integer
#  minimum_minutes_billed_cancelled_level_2         :integer
#  minimum_minutes_paid                             :integer
#  minimum_minutes_paid_cancelled_level_1           :integer
#  minimum_minutes_paid_cancelled_level_2           :integer
#  name                                             :string
#  trigger_for_billing_increment                    :integer
#  trigger_for_cancel_level1                        :integer
#  trigger_for_cancel_level2                        :integer
#  trigger_for_discount_rate                        :integer
#  trigger_for_mileage                              :integer
#  trigger_for_rush_rate                            :integer
#  trigger_for_travel_time                          :integer
#  weekend_availability_end_seconds1                :integer
#  weekend_availability_end_seconds2                :integer
#  weekend_availability_start_seconds1              :integer
#  weekend_availability_start_seconds2              :integer
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  account_id                                       :uuid
#
class PayBillConfig < ApplicationRecord
  belongs_to :account

  has_many :pay_bill_config_customers, dependent: :destroy
  has_many :customers, through: :pay_bill_config_customers, class_name: "Account", foreign_key: :account_id

  has_many :pay_bill_config_interpreters, dependent: :destroy
  has_many :interpreters, through: :pay_bill_config_interpreters, class_name: "User", foreign_key: :user_id

  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :pay_bill_configs, partial: "pay_bill_configs/index", locals: {pay_bill_config: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :pay_bill_configs, target: dom_id(self, :index) }

  def active_timezone
    # Need to implement Agency time zones still
    tz = Account.timezone || ActiveSupport::TimeZone["Pacific Time (US & Canada)"]
    tz.name
  end

  def start_hour(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).hour
      end
    else
      self[column] / 3600
    end
  end

  def start_minute(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).min
      end
    else
      ((self[column] / 3600.0).modulo(1) * 60).to_i
    end
  end

  def end_hour(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).hour
      end
    else
      self[column] / 3600
    end
  end

  def end_minute(column, use_time_libs: false)
    return nil if self[column].blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + self[column]).min
      end
    else
      ((self[column] / 3600.0).modulo(1) * 60).to_i
    end
  end

  def make_weekend1_times_from_hash(thash)
    start_times1 = thash.try(:fetch, :weekend_availability_start_seconds1)
    end_times1 = thash.try(:fetch, :weekend_availability_end_seconds1)

    return false if start_times1.blank? || end_times1.blank?

    return false if start_times1[:hour].blank? || end_times1[:hour].blank? || start_times1[:minute].blank? || end_times1[:minute].blank?

    begin
      start_hour1 = Integer(start_times1[:hour].sub(/^0/, ""))
      start_minute1 = Integer(start_times1[:minute].sub(/^0/, ""))

      end_hour1 = Integer(end_times1[:hour].sub(/^0/, ""))
      end_minute1 = Integer(end_times1[:minute].sub(/^0/, ""))

      self.weekend_availability_start_seconds1 = (start_hour1 * 3600) + (start_minute1 * 60)
      self.weekend_availability_end_seconds1 = (end_hour1 * 3600) + (end_minute1 * 60)
    rescue => e
      logger.warn "Error: #{e}"
      false
    end
  end

  def make_weekend2_times_from_hash(thash)
    start_times2 = thash.try(:fetch, :weekend_availability_start_seconds2)
    end_times2 = thash.try(:fetch, :weekend_availability_end_seconds2)

    return false if start_times2.blank? || end_times2.blank?

    return false if start_times2[:hour].blank? || end_times2[:hour].blank? || start_times2[:minute].blank? || end_times2[:minute].blank?

    begin
      start_hour2 = Integer(start_times2[:hour].sub(/^0/, ""))
      start_minute2 = Integer(start_times2[:minute].sub(/^0/, ""))

      end_hour2 = Integer(end_times2[:hour].sub(/^0/, ""))
      end_minute2 = Integer(end_times2[:minute].sub(/^0/, ""))

      self.weekend_availability_start_seconds2 = (start_hour2 * 3600) + (start_minute2 * 60)
      self.weekend_availability_end_seconds2 = (end_hour2 * 3600) + (end_minute2 * 60)
    rescue => e
      logger.warn "Error: #{e}"
      false
    end
  end

  def make_afterhours1_times_from_hash(thash)
    start_times1 = thash.try(:fetch, :afterhours_availability_start_seconds1)
    end_times1 = thash.try(:fetch, :afterhours_availability_end_seconds1)

    return false if start_times1.blank? || end_times1.blank?

    return false if start_times1[:hour].blank? || end_times1[:hour].blank? || start_times1[:minute].blank? || end_times1[:minute].blank?

    begin
      start_hour1 = Integer(start_times1[:hour].sub(/^0/, ""))
      start_minute1 = Integer(start_times1[:minute].sub(/^0/, ""))

      end_hour1 = Integer(end_times1[:hour].sub(/^0/, ""))
      end_minute1 = Integer(end_times1[:minute].sub(/^0/, ""))

      self.afterhours_availability_start_seconds1 = (start_hour1 * 3600) + (start_minute1 * 60)
      self.afterhours_availability_end_seconds1 = (end_hour1 * 3600) + (end_minute1 * 60)
    rescue => e
      logger.warn "Error: #{e}"
      false
    end
  end

  def make_afterhours2_times_from_hash(thash)
    start_times2 = thash.try(:fetch, :afterhours_availability_start_seconds2)
    end_times2 = thash.try(:fetch, :afterhours_availability_end_seconds2)

    return false if start_times2[:hour].blank? || end_times2[:hour].blank? || start_times2[:minute].blank? || end_times2[:minute].blank?

    begin
      start_hour2 = Integer(start_times2[:hour].sub(/^0/, ""))
      start_minute2 = Integer(start_times2[:minute].sub(/^0/, ""))

      end_hour2 = Integer(end_times2[:hour].sub(/^0/, ""))
      end_minute2 = Integer(end_times2[:minute].sub(/^0/, ""))

      self.afterhours_availability_start_seconds2 = (start_hour2 * 3600) + (start_minute2 * 60)
      self.afterhours_availability_end_seconds2 = (end_hour2 * 3600) + (end_minute2 * 60)
    rescue => e
      logger.warn "Error: #{e}"
      false
    end
  end
end
