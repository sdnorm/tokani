// pay_bill_config_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleHideMinMinutesBilled", "toggleHideMinMinutesBilledCancel"]
  static values = {inverted: Boolean}

  toggleHideMinMinutesBilled(event) {
    let checked = event.target.checked
    const inverted = this.invertedValue

    if (inverted == true) {
      checked = !checked
    }
    if (checked) {
      this.toggleHideMinMinutesBilledTarget.querySelectorAll("input,select").forEach((i) => i.disabled = false)
      this.toggleHideMinMinutesBilledTarget.classList.remove('hidden')
      
    } else {
      this.toggleHideMinMinutesBilledTarget.querySelectorAll("input,select").forEach((i) => i.value = "" )
      this.toggleHideMinMinutesBilledTarget.querySelectorAll("input,select").forEach((i) => i.disabled = true)
      this.toggleHideMinMinutesBilledTarget.classList.add('hidden')
    }

  }

  toggleHideMinMinutesBilledCancel(event) {
    let checked = event.target.checked
    const inverted = this.invertedValue
    
    if (inverted == true) {
      checked = !checked
    }
    if (checked) {
      this.toggleHideMinMinutesBilledCancelTarget.querySelectorAll("input,select").forEach((i) => i.disabled = false)
      this.toggleHideMinMinutesBilledCancelTarget.classList.remove('hidden')
      
    } else {
      this.toggleHideMinMinutesBilledCancelTarget.querySelectorAll("input,select").forEach((i) => i.value = "" )
      this.toggleHideMinMinutesBilledCancelTarget.querySelectorAll("input,select").forEach((i) => i.disabled = true)
      this.toggleHideMinMinutesBilledCancelTarget.classList.add('hidden')
    }

  }


}