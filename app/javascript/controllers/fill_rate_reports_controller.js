// fill_rate_reports_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customers", "interpreters", "languages", "generate"]

  connect() {
    console.log("fill rate reports controller connected...")
  }

  selected(event) {

    let report_type = event.target.value

    console.log("Report type selected", report_type)

    if (report_type =='') {
      this.customersTarget.classList.add('hidden')
      this.interpretersTarget.classList.add('hidden')
      this.languagesTarget.classList.add('hidden')
      this.generateTarget.classList.add('hidden')
    } else if (report_type == 'customer') {
      this.customersTarget.classList.remove('hidden')
      this.interpretersTarget.classList.add('hidden')
      this.languagesTarget.classList.add('hidden')
      this.generateTarget.classList.remove('hidden')
    } else if (report_type == 'interpreter') {
      this.interpretersTarget.classList.remove('hidden')
      this.customersTarget.classList.add('hidden')
      this.languagesTarget.classList.add('hidden')
      this.generateTarget.classList.remove('hidden')
    } else if (report_type == 'language') {
      this.languagesTarget.classList.remove('hidden')
      this.interpretersTarget.classList.add('hidden')
      this.customersTarget.classList.add('hidden')
      this.generateTarget.classList.remove('hidden')
    }
  }

}