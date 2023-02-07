// customer_sites_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sites", "departments", "checkbox"]

  connect() {
    console.log("customer sites controller connected...")
  }

  customerSelected(event) {
    console.log("customerSelected called", event)

    let agency_customer_ids = []

    this.checkboxTargets.forEach((child) => {
      if (child.checked) {
        console.log("child ", child)
        console.log("is checked")
        agency_customer_ids.push(child.value)
      }
    })
    console.log("agency_customer_ids: " + agency_customer_ids)

    this.sitesTarget.classList.remove('hidden')

    if (agency_customer_ids.length == 1) {
      fetch('/sites/dropdown_for_reports?agency_customer_id=' + agency_customer_ids)
        .then(response => response.text())
        .then(html => this.sitesTarget.innerHTML = html)

    } else if (agency_customer_ids.length > 1) {
      this.sitesTarget.innerHTML = "<p>Site selection is disabled when multiple Agency Customers have been selected.</p>"
    } else {
      this.sitesTarget.innerHTML = ''
      this.departmentsTarget.innerHTML = ''
    }
  }

  siteSelected(event) {
    let site_ids = this.getSelectValues(event.target)

    console.log("Site IDs: ")
    console.log(site_ids)

    this.departmentsTarget.classList.remove('hidden')

    console.log("fetching: " + '/sites/departments_dropdown_for_reports?site_ids=' + site_ids)
    fetch('/sites/departments_dropdown_for_reports?site_ids=' + site_ids)
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