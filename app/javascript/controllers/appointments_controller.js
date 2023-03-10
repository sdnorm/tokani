import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // console.log("Its connected to DOM!")
  }

  handleStatusEditableBehaviour() {
    const statusElement = document.getElementById("appointmentStatus")
    this.options = { "Created": 1, "Cancelled": 5, "Finished": 6 }

    const dropdown = createDropdownWithOptions(this.options, statusElement)

    dropdown.addEventListener('change', () => {
      updateStatusOnServer(this.options, dropdown)
    })    
  }
}

// Helper methods
let createDropdownWithOptions = (options, statusElement) => {
  const dropdown = document.createElement("select")

  for (const option of Object.keys(options)) {
    const optionElement = document.createElement("option")
    optionElement.value = option
    optionElement.text = option
    dropdown.appendChild(optionElement)
  }

  dropdown.value = statusElement.textContent
  statusElement.replaceWith(dropdown)
  return dropdown
}

let updateStatusOnServer = (options, dropdown) => {
  let status = dropdown.value

  if (status === "Created") {
    const spanElement = createSpanElement()
    spanElement.textContent = "Created"
    dropdown.replaceWith(spanElement)
    return
  }
    

  const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

  const appointmentId = document.querySelector(".mainAppointmentContainer").id.split("_")[1]
  const selectedOptionValue = options[status]
  
  fetch(`/appointments/${appointmentId}/status`, {
    method: "PATCH",
    headers: { 
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken // Include the CSRF token in the headers
    },
    body: JSON.stringify({ appointment: { status: selectedOptionValue } })
  }).then((response) => response.json())
    .then((data) => {
      const spanElement = createSpanElement()
      let formattedStatus = capitalize(data.status)

      spanElement.textContent = formattedStatus
      dropdown.replaceWith(spanElement)
    }).catch((error) => alert(error))
}

let createSpanElement = () => {
  const spanElement = document.createElement("span")
  spanElement.setAttribute('id', 'appointmentStatus')
  spanElement.setAttribute('data-action', 'click->appointments#handleStatusEditableBehaviour')
  return spanElement
}

let capitalize = (str) => {
  return str.charAt(0).toUpperCase() + str.slice(1)
}