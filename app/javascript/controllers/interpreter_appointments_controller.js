// interpreter_appointments_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "appointments"]

  changed(event) {
    Rails.fire(this.formTarget, "submit")
  }

  handleResults() {
    const [data, status, xhr] = event.detail
    this.appointmentsTarget.innerHTML = xhr.response
  }

}