import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {}

  handleStatusEditableBehaviour() {
    const statusElement = document.getElementById("appointmentStatus")
    const statusDropdown = document.getElementById("appointmentStatusDropdown")
    toggleSpanAndDropdownView(statusElement, statusDropdown)
    
    statusDropdown.addEventListener('change', () => {
      updateStatusOnServer(statusElement, statusDropdown)
    })
  }
}

// Helper methods
let toggleSpanAndDropdownView = (statusElement, statusDropdown, hideStatusAndShowDropdown = true) => {
  if (hideStatusAndShowDropdown) {
    statusElement.style.display = "none"
    statusDropdown.style.display = "block"
  } else {
    statusElement.style.display = "block"
    statusDropdown.style.display = "none"
  }
}

let capitalize = (str) => {
  return str.charAt(0).toUpperCase() + str.slice(1)
}

let updateStatusOnServer = (statusElement, dropdown) => {
  let status = dropdown.selectedOptions[0].textContent

  if (status === "Created") {
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