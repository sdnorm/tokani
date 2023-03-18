module BillRatesHelper

    def round_time_options
        BillRate.round_times.to_a.map { |entry| [entry[0].titleize, entry[0]] }
      end

      def round_increment_options
        [
          ["1 minute", 1],
          ["5 minutes", 5],
          ["10 minutes", 10],
          ["15 minutes", 15],
          ["20 minutes", 20],
          ["30 minutes", 30],
          ["1 hour", 60],
          
        ]
      end

      def rush_overage_trigger_options
        [
          ["12 hours", 12],
          ["24 hours", 24],
          ["36 hours", 36],
          ["48 hours", 48],
          ["72 hours", 72],
          
        ]
      end

      def cancel_rate_trigger_options
        [
            ["12 hours", 12],
            ["24 hours", 24],
            ["36 hours", 36],
            ["48 hours", 48],
            ["72 hours", 72],
          
        ]
      end

      def start_config(bill_rate, start_column)
        if bill_rate.start_hour(start_column).blank?
          time_string = "N/A"
        else
          time = "#{bill_rate.start_hour(start_column).to_s.rjust(2, "0")}:#{bill_rate.start_minute(start_column).to_s.rjust(2, "0")}"
          # time_string = Time.find_zone(Agency.timezone).parse(time).strftime("%I:%M %p")
          time_string = Time.find_zone("Pacific Time (US & Canada)").parse(time).strftime("%I:%M %p")
        end
    
        time_string
      end
    
      def end_config(bill_rate, end_column)
        if bill_rate.end_hour(end_column).blank?
          time_string = "N/A"
        else
          time = "#{bill_rate.end_hour(end_column).to_s.rjust(2, "0")}:#{bill_rate.end_minute(end_column).to_s.rjust(2, "0")}"
          # time_string = Time.find_zone(Agency.timezone).parse(time).strftime("%I:%M %p")
          time_string = Time.find_zone("Pacific Time (US & Canada)").parse(time).strftime("%I:%M %p")
        end
        time_string
      end

end
