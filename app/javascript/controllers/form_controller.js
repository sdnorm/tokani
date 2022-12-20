// form_controller.js

import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js'

export default class extends Controller {
  static targets = ["template", "addDst", "select", "addHeader", "templateHeader", "showFile"]

  connect() {
    console.log("form controller connected...")
  }

  addFields() {
    const my_template = this.templateTarget.innerHTML
    const my_templateHeader = this.templateHeaderTarget.innerHTML
    if(this.addHeaderTarget.querySelector('#headerRow') == null){
      this.addHeaderTarget.insertAdjacentHTML('afterbegin', my_templateHeader)
      this.addDstTarget.insertAdjacentHTML('beforeend', my_template)
    }
    else{
      this.addDstTarget.insertAdjacentHTML('beforeend', my_template)
    }
  }

  showFileName(event){   
     this.showFileTarget.placeholder = event.target.files[0].name
  }

  clearForm() {
    let addr = new URL(window.location)
    addr.searchParams.forEach(function(value, key) {
      addr.searchParams.set(key, "") 
    });
    Turbo.visit(addr)
  }
}