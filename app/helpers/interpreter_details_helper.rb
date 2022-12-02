module InterpreterDetailsHelper
    def interpreter_type_options
        return InterpreterDetail.interpreter_types.to_a.map { |entry| [entry[0].titleize, entry[0]] }
      end
    
      def gender_options
        return InterpreterDetail.genders.to_a.map { |entry| [entry[0].titleize, entry[0]] }
      end

      def view_name
          return "#{self.lname}, #{self.fname}"
       end
end
