// process_batches_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customers", "interpreters"]

  processBy(event) {

    let batch_type = event.target.value

    if (batch_type == 'customer') {
      // Show the Process by Customer list
      this.customersTarget.classList.remove('hidden')
      // Hide the Process by Interpreter list
      this.interpretersTarget.classList.add('hidden')
    } else {
      // Show the Process by Interpreter list
      this.interpretersTarget.classList.remove('hidden')
      // Hide the Process by Customers list
      this.customersTarget.classList.add('hidden')
    }
  }

}