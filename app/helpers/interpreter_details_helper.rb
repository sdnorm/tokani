module InterpreterDetailsHelper
  def interpreter_type_options
    InterpreterDetail.interpreter_types.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def gender_options
    InterpreterDetail.genders.to_a.map { |entry| [entry[0].titleize, entry[0]] }
  end

  def view_name
    "#{lname}, #{fname}"
  end
end
