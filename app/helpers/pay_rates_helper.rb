module PayRatesHelper
  def selected_languages(new_rate, languages)
    if new_rate
      ""
    else
      "data-multiselect-selected-value='#{languages}'"
    end
  end

  def selected_interpreters(new_rate, ints)
    if new_rate
      ""
    else
      "data-multiselect-selected-value='#{ints}'"
    end
  end
end
