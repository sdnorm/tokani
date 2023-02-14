import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  // static values = { message: String};
  static targets = ["fieldset"]

  selectFieldset(event) {
    
    // disable all fieldsets, only enable the current one
    // add to selector classes for 'input like' divs that you want to disable.
    const selectedFieldset = event.params.fieldset
    this.fieldsetTargets.forEach( fs => {
      if (fs.id == selectedFieldset) {
        fs.disabled = false
        fs.querySelectorAll('input').forEach(so => {so.disabled = false })
        fs.querySelectorAll('.selected-option', 'div.input-group').forEach(so => {so.classList.remove('disabled') })
      } else {
        fs.disabled = true
        fs.querySelectorAll('input').forEach(so => {so.disabled = true })
        fs.querySelectorAll('input').forEach(so => {so.value = "" })
        fs.querySelectorAll('.selected-option').forEach(so => {so.classList.add('disabled')})
      }
    })

  }

}