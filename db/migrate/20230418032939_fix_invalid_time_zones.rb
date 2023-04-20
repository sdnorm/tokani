class FixInvalidTimeZones < ActiveRecord::Migration[7.0]
  def change
    User.all.each do |u|
      if u.time_zone&.include?("GMT-")
        # If they have an invalid time zone, just set it to Pacific Time
        u.update(time_zone: "Pacific Time (US & Canada)")
      end
    end
  end
end
