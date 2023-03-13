// interpreter_appointments_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "appointments", "status", "displayRange"]

  connect() {
    const checkboxOpenedStatus = this.statusTarget.querySelectorAll("input[type='radio'][value='opened']")[0]

    const checkboxDisplayRange = this.displayRangeTarget.querySelectorAll("input[type='radio'][value='today']")[0]

    if (checkboxOpenedStatus !== undefined) {
      checkboxOpenedStatus.click()
    }

    if (checkboxDisplayRange !== undefined) {
      setTimeout(() => { checkboxDisplayRange.click() }, 400)
    }
  }

  changed(event) {
    Rails.fire(this.formTarget, "submit")
  }

  handleResults() {
    const [data, status, xhr] = event.detail
    this.appointmentsTarget.innerHTML = xhr.response
  }
}
