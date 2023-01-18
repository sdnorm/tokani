// select_group_controller.js

import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js'


export default class extends Controller {

  static targets = ["template", "addDst", "select"]

  
  updateSelectRemote(event) {
    
    let params = new URLSearchParams()
    
    params.append(event.params.selectKey, event.target.selectedOptions[0].value)
    
    // params.append("target", this.selectTarget.id)
    params.append("target", event.params.selectUpdateTarget)

    if (event.params.selectClearTarget !== undefined) {
      params.append('clear', event.params.selectClearTarget)
    }

    const url = event.params.url

    // actions are taken care of directly by turbo stream directives.
    get(`${url}?${params}`, {
      responseKind: "turbo-stream"
    })


  }


  
}