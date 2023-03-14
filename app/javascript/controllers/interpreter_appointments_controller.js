// interpreter_appointments_controller.js

import { Controller } from "@hotwired/stimulus"
import { arrayToSentence, toSentence } from "../helpers"

export default class extends Controller {
  static targets = ["form", "appointments", "status", "displayRange", "modality"]

  connect() {
    const checkboxOpenedStatus = this.statusTarget.querySelectorAll("input[type='radio'][value='opened']")[0]

    const checkboxDisplayRange = this.displayRangeTarget.querySelectorAll("input[type='radio'][value='today']")[0]

    if (checkboxOpenedStatus !== undefined) {
      checkboxOpenedStatus.click()
    }
  }

  changed(event) {
    Rails.fire(this.formTarget, "submit")
  }

  handleResults() {
    const [data, status, xhr] = event.detail
    this.appointmentsTarget.innerHTML = xhr.response
  }

  toggleNestedDropdown() {
    const nestedDropdown = this.displayRangeTarget.querySelector(".nestedDropdown")
    nestedDropdown.classList.toggle("hidden")
  }

  updateCurrentFilterText(event) {
    const categoryFilter = event.target.dataset.categoryFilter
    const categoriesTextContainer = this.formTarget.querySelector("#categoriesTextContainer")
    const timeframeTextContainer = this.formTarget.querySelector("#timeframeTextContainer")

    if (categoryFilter &&!categoriesTextContainer.innerHTML.includes(categoryFilter)) {
      categoriesTextContainer.innerHTML = categoryFilter
    }
  }

  toggleCurrentTimeFilterText() {
    const selectedFilters = this.displayRangeTarget.querySelectorAll("input[type=checkbox]:checked")

    const selectedFiltersValues = [...selectedFilters].map((item) => {
      return item?.value
    })

    timeframeTextContainer.innerHTML = (arrayToSentence(selectedFiltersValues) + "")

    if (selectedFilters.length == 0) {
      timeframeTextContainer.innerHTML = "All"
    }
  }

  toggleModalityFilterText() {
    const selectedFilters = this.modalityTarget.querySelectorAll("input[type=checkbox]:checked")

    const selectedFiltersValues = [...selectedFilters].map((item) => {
      return toSentence(item?.value)
    })

    modalitiesTextContainer.innerHTML = (arrayToSentence(selectedFiltersValues))

    if (selectedFilters.length == 0) {
      modalitiesTextContainer.innerHTML = "All"
    }
  }
}
