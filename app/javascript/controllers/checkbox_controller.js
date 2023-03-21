// checkbox_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleHide", "getInactive", "showFields"]
  static values = {inverted: Boolean}

  toggleHide(event) {
    let checked = event.target.checked
    
    // const inverted = this.invertedValue
  
    // if (inverted == true) {
    //   checked = !checked
    // }
    if (!checked) {
      this.toggleHideTarget.querySelectorAll("input,select").forEach((i) => i.disabled = false)
      this.toggleHideTarget.classList.remove('hidden')
      
    } else {
      this.toggleHideTarget.querySelectorAll("input,select").forEach((i) => i.value = "" )
      this.toggleHideTarget.querySelectorAll("input,select").forEach((i) => i.disabled = true)
      this.toggleHideTarget.classList.add('hidden')
      
    }

  }





  getInactive(event) {

    const name = event.target.name;
    const checked = event.target.checked;
    const searchParams = new URLSearchParams(window.location.search);
    searchParams.set(name, checked);
    const updatedParams = searchParams.toString();
    const url = `${window.location.pathname}?${updatedParams}`;
    Turbo.visit(url);
    
  }

  showFields() {
    this.showFieldsTarget.classList.toggle('hidden')
  }

}