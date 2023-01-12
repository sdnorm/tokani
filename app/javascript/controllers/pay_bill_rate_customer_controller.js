// pay_bill_rate_customer_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sites", "departments"]

  connect() {
    console.log("pay bill rate customer controller connected...")
  }

  customerSelected(event) {
    console.log("customerSelected ....")
    console.log(event)

    let customer_id = event.target.value

    this.sitesTarget.classList.remove('hidden')

    fetch('/sites/dropdown?account_id=' + customer_id)
      .then(response => response.text())
      .then(html => this.sitesTarget.innerHTML = html)
  }

  siteSelected(event) {

    let site_ids = this.getSelectValues(event.target)

    this.departmentsTarget.classList.remove('hidden')

    fetch('/sites/departments_dropdown?site_ids=' + site_ids)
      .then(response => response.text())
      .then(html => this.departmentsTarget.innerHTML = html)

  }

  getSelectValues(select) {
    var result = [];
    var options = select && select.options;
    var opt;

    for (var i=0, iLen=options.length; i<iLen; i++) {
      opt = options[i];

      if (opt.selected) {
        result.push(opt.value || opt.text);
      }
    }
    return result;
  }

}