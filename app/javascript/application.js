/* eslint no-console:0 */

// Rails functionality
import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"

// Make accessible for Electron and Mobile adapters
window.Rails = Rails

require("@rails/activestorage").start()
import "@rails/actiontext"

// ActionCable Channels
import "./channels"

// Stimulus controllers
import "./controllers"

// Jumpstart Pro & other Functionality
import "./src/**/*"
require("local-time").start()

import "flowbite"
// Start Rails UJS
Rails.start()

import "chartkick/chart.js"

Turbo.setConfirmMethod((message) => {
  let dialog = document.getElementById("turbo-confirm")
  dialog.querySelector("h4").textContent = message
  dialog.showModal()

  return new Promise((resolve) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue == "confirm")
    }, { once: true })
  })
})
