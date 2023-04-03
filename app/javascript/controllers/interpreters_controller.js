import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"]

  removeElement() {
    const index = this.element.querySelector("button").dataset.index

    const availabilityFormElement = document.querySelector(`#new_availability_form_wrapper`)

    availabilityFormElement.remove()
  }

  submitForm(event) {
    const previousValue = event.target.dataset.selectedValue

    const submitTimezoneBtn = document.querySelector("#submit-timezone__btn")

    if (!submitTimezoneBtn.click()) {
      event.target.value = previousValue
    }
  }
}
