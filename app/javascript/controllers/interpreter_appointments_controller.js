// interpreter_appointments_controller.js

import { Controller } from "@hotwired/stimulus"
import { arrayToSentence, toSentence } from "../helpers"

export default class extends Controller {
  static targets = ["form", "appointments", "status", "displayRange", "modality"]

  connect() {
    const checkboxOpenedStatus = this.statusTarget.querySelectorAll("input[type='radio'][value='all']")[0]

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
    const statusFilter = event.target.dataset.statusFilter
    const statusesTextContainer = this.formTarget.querySelector("#statusesTextContainer")
    const timeframeTextContainer = this.formTarget.querySelector("#timeframeTextContainer")

    if (statusFilter &&!statusesTextContainer.innerHTML.includes(statusFilter)) {
      statusesTextContainer.innerHTML = statusFilter
    }
  }

  toggleCurrentTimeFilterText() {
    const selectedFilters = this.displayRangeTarget.querySelectorAll("input[type=checkbox]:checked")

    const selectedFiltersValues = [...selectedFilters].map((item) => {
      return item?.value
    })

    timeframeTextContainer.innerHTML = (arrayToSentence(selectedFiltersValues) + "'s ")

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
      modalitiesTextContainer.innerHTML = "Modality"
    }
  }

  sort(event) {
    const sortType = event.target.dataset.sortType
    // Get the hidden field node
    const field = event.target.nextElementSibling
    const icon = field.nextElementSibling
    field.value == sortType ? field.value = "" : field.value = true
    icon.classList.toggle("rotate-180")
    this.search()
  }

  search() {
    Rails.fire(this.formTarget, "submit")
  }
}
