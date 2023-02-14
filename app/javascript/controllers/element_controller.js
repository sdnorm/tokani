// remove_controller
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["remove"]
  
  remove(event) {
    if (this.hasRemoveTarget && !this.removeTarget.classList.contains("disabled")) {
      this.removeTarget.remove()
    }
  }
}