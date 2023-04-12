import { Autocomplete } from 'stimulus-autocomplete'

export default class extends Autocomplete {

  static targets = ["input",  "hidden", "results", "agencyCustomerId", "languageId", 'chipTemplate', 'chipList']

  initialize() {
    super.initialize()
  }

  connect() {
    super.connect()
  }

  commit(selected) {
    if (selected.getAttribute("aria-disabled") === "true") return

    if (selected instanceof HTMLAnchorElement) {
      selected.click()
      this.close()
      return
    }

    const textValue = selected.getAttribute("data-autocomplete-label") || selected.textContent.trim()
    const value = selected.getAttribute("data-autocomplete-value") || textValue
    const template = this.chipTemplateTarget.content.firstElementChild.cloneNode(true)
    template.querySelector('.selected-option-label').innerHTML = textValue
    template.querySelector("[name='appointment[interpreter_req_ids][]']").value = value
    this.chipListTarget.append(template)

    this.inputTarget.value = ''

    this.inputTarget.focus()
    this.hideAndRemoveOptions()

    this.element.dispatchEvent(
      new CustomEvent("autocomplete.change", {
        bubbles: true,
        detail: { value: value, textValue: textValue, selected: selected }
      })
    )
  }

  buildURL(){
    const query = this.inputTarget.value.trim()
    // const query1 = this.assignedTarget.value.trim()
console.log(this.inputTarget)
console.log(this.assignedTarget)
    if (!query || query.length < this.minLengthValue) {
      this.hideAndRemoveOptions()
      return null
    }

    const url = new URL(this.urlValue, window.location.href)

    const params = new URLSearchParams(url.search.slice(1))
    params.append("q", query)

    
    if (this.hasLanguageIdTarget != true) {
      this.hideAndRemoveOptions()
      return null
    }

    // const agency_customer_id = this.agencyCustomerIdTarget.value || this.agencyCustomerIdTarget.selectedOptions[0].value
    const language_id = this.languageIdTarget.value || this.languageIdTarget.selectedOptions[0].value
    
    // const modality = this.modalityTarget.value || this.modalityTarget.selectedOptions[0].value
    
    params.set("language_id", language_id)
    // params.set("modality", modality)


    url.search = params.toString()
    
    return url.toString()
  }




}