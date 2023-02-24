# == Schema Information
#
# Table name: availabilities
#
#  id            :bigint           not null, primary key
#  end_seconds   :integer
#  in_person     :boolean
#  phone         :boolean
#  start_seconds :integer
#  time_zone     :string
#  video         :boolean
#  wday          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  backport_id   :integer
#  user_id       :uuid             not null
#
# Indexes
#
#  index_availabilities_on_user_id  (user_id)
#  user_start_secs_end_secs_ix      (user_id,start_seconds,end_seconds)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Availability < ApplicationRecord
  belongs_to :interpreter, foreign_key: "user_id", class_name: "User"

  validate :valid_modalities
  validates :start_seconds, numericality: {greater_than_or_equal_to: 0, less_than: 86_400, message: "Is Not Valid"}
  validates :end_seconds, numericality: {greater_than_or_equal_to: 0, less_than: 86_400, message: "Is Not Valid"}
  validate :start_is_less_than_end

  before_create :set_timezone

  def set_timezone
    self.time_zone = interpreter.time_zone
  end

  def interpreter_id=(int_id)
    self.user_id = int_id
  end

  def interpreter_id
    user_id
  end

  def set_times_from_hash(thash)
    start_times = thash.try(:fetch, :start)
    end_times = thash.try(:fetch, :finish)

    return false if start_times.blank? || end_times.blank?

    return false if start_times[:hour].blank? || end_times[:hour].blank? || start_times[:minute].blank? || end_times[:minute].blank?

    begin
      start_hour = Integer(start_times[:hour].sub(/^0/, ""))
      start_minute = Integer(start_times[:minute].sub(/^0/, ""))

      end_hour = Integer(end_times[:hour].sub(/^0/, ""))
      end_minute = Integer(end_times[:minute].sub(/^0/, ""))

      self.start_seconds = (start_hour * 3600) + (start_minute * 60)
      self.end_seconds = (end_hour * 3600) + (end_minute * 60)
    rescue => e
      logger.info "Failed to set times from hash in Availability: #{e}"
      false
    end
  end

  def start_hour(use_time_libs: false)
    return nil if start_seconds.blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + start_seconds).hour
      end
    else
      start_seconds / 3600
    end
  end

  def start_minute(use_time_libs: false)
    return nil if start_seconds.blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + start_seconds).min
      end
    else
      ((start_seconds / 3600.0).modulo(1) * 60).to_i
    end
  end

  def end_hour(use_time_libs: false)
    return nil if end_seconds.blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + end_seconds).hour
      end
    else
      end_seconds / 3600
    end
  end

  def end_minute(use_time_libs: false)
    return nil if end_seconds.blank?

    if use_time_libs == true
      Time.use_zone(timezone) do
        return (Time.zone.now.beginning_of_day + end_seconds).min
      end
    else
      ((end_seconds / 3600.0).modulo(1) * 60).to_i
    end
  end

  def day_name
    Date::DAYNAMES[wday]
  end

  def modalities
    retval = []
    %i[phone in_person video].each do |attr|
      retval << attr if send(attr) == true
    end

    retval
  end

  # NK *** Placeholder, not meant for long term use
  def to_s
    "From #{start_hour.to_s.rjust(2, "0")}:#{start_minute.to_s.rjust(2, "0")} to #{end_hour.to_s.rjust(2, "0")}:#{end_minute.to_s.rjust(2, "0")} on #{day_name}.  Modalities: #{modalities.map { |m| m.to_s.titleize }.join(", ")}"
  end

  private

  # we have a different validation for start_seconds, end_seconds
  def start_is_less_than_end
    return false if start_seconds.blank? || end_seconds.blank?

    unless start_seconds < end_seconds
      errors.add(:start_seconds, "Must be before End Time")
      errors.add(:end_seconds, "Must be after Start Time")
      return false
    end
    true
  end

  def valid_modalities
    valid = false
    %i[phone in_person video].each do |attr|
      valid ||= send(attr)
    end

    if valid != true
      errors.add(:base, "At least one modality must be sellected")
      return false
    end

    true
  end
end
