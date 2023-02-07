// select_financial_report_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  selected(event) {

    let report_type = event.target.value

    //console.log("Report type selected", report_type)

    if (report_type == 'financial') {
      // Go to the Financial report page
      Turbo.visit('/reports/financial');
    } else if (report_type == 'fill-rate') {
      // Go to the Fill Rate report page
      Turbo.visit('/reports/fill_rate');
    }
  }

}