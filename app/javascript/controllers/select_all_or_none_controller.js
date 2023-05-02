// select_all_or_none_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkboxName", "checkboxes"]

  toggle(event) {
    let checkedBooleanVal = event.currentTarget.checked
    let i = 0;
    while (i < this.checkboxesTargets.length) {
      this.checkboxesTargets[i].checked = checkedBooleanVal
      i++;
    }
  }

}