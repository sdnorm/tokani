import { Controller } from "@hotwired/stimulus"
import { arrayToSentence, toSentence } from "../helpers"
import debounce from "debounce"

export default class extends Controller {
  static targets = ["form", "appointments", "status", "displayRange", "modality"]

  initialize() {
    this.search = debounce(this.search.bind(this), 300)
  }

  connect() {
    const checkboxOpenedStatus = this.statusTarget.querySelectorAll("input[type='radio'][value='all']")[0]

    if (checkboxOpenedStatus !== undefined) {
      checkboxOpenedStatus.click()
    }
  }

  handleStatusEditableBehaviour() {
    const statusElement = document.getElementById("appointmentStatus")
    const statusDropdown = document.getElementById("appointmentStatusDropdown")
    toggleSpanAndDropdownView(statusElement, statusDropdown)

    statusDropdown.addEventListener('change', () => {
      updateStatusOnServer(statusElement, statusDropdown)
    })
  }

  updateCurrentFilterText(event) {
    const statusFilter = event.target.dataset.statusFilter
    const statusesTextContainer = this.formTarget.querySelector("#statusesTextContainer")
    const timeframeTextContainer = this.formTarget.querySelector("#timeframeTextContainer")

    if (statusFilter && !statusesTextContainer.innerHTML.includes(statusFilter)) {
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

  submitForm(event) {
    const confirmCancelBtn = document.querySelector("#confirm-cancel")

    if (!confirmCancelBtn.click()) {
      event.target.checked = false
    }
  }

  showReason(event) {
    event.preventDefault()
    const cancelForm = document.querySelector(".cancel-reason-container")

    cancelForm.classList.toggle("hidden")
  }
}

// Helper methods
let toggleSpanAndDropdownView = (statusElement, statusDropdown, hideStatusAndShowDropdown = true) => {
  if (hideStatusAndShowDropdown) {
    statusElement.style.display = "none"
    statusDropdown.style.display = "block"
  } else {
    statusElement.style.display = "block"
    statusElement.setAttribute("class", "inline-block p-2 -mx-2 hover:bg-gray-100 cursor-pointer")
    statusElement.setAttribute("title", "Click to edit status")
    statusDropdown.style.display = "none"
  }
}

let capitalize = (str) => {
  return str.charAt(0).toUpperCase() + str.slice(1)
}

let updateStatusOnServer = (statusElement, dropdown) => {
  let selectedOption = dropdown.selectedOptions[0]
  let status = selectedOption.textContent

  if (status === "Created" || selectedOption.value === '') {
    toggleSpanAndDropdownView(statusElement, dropdown, false)
    return
  }

  const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

  const appointmentId = document.querySelector(".mainAppointmentContainer").id.split("_")[1]
  const selectedOptionValue = parseInt(dropdown.selectedOptions[0].value)

  fetch(`/appointments/${appointmentId}/status`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken // Include the CSRF token in the headers
    },
    body: JSON.stringify({ appointment: { status: selectedOptionValue } })
  }).then((response) => response.json())
    .then((data) => {
      let formattedStatus = capitalize(data.status)
      statusElement.textContent = formattedStatus
      toggleSpanAndDropdownView(statusElement, dropdown, false)
    }).catch((error) => alert(error))
}


