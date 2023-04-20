// toggle_video_link_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["videoLink"]

  toggle(event) {

    let modality = event.target.value
    console.log("modality ", modality)
    if (modality == 'video') {
      // Enable the video link
      this.videoLinkTarget.removeAttribute('disabled')
    } else {
      // Disable the video link
      this.videoLinkTarget.setAttribute("disabled", true)
    }
  }

}