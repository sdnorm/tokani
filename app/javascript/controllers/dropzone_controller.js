import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"
import Dropzone from "dropzone"
import { getMetaValue, findElement, removeElement, insertAfter } from "../helpers"

Dropzone.autoDiscover = false

export default class extends Controller {
  static targets = ["input", "existingImageInput", "dropHere"]
  static values = {
    images: { type: Array, default: [] },
    maxFiles: { type: Number, default: 1 },
    maxFileSize: { type: Number, default: 2 }
  }

  connect() {
    this.dropZone = createDropZone(this)
    this.hideFileInput()
    this.bindEvents()
  }

  // Private

  hideFileInput() {
    this.inputTarget.disabled = true
    this.inputTarget.style.display = "none"
  }

  bindEvents() {
    const self = this

    this.dropZone.on("addedfile", (file) => {
      setTimeout(() => { file.accepted && createDirectUploadManager(this, file).start() }, 500)
    })

    this.dropZone.on("removedfile", (file) => {
      // NK hacked to allow previously set images to
      if (file.controller) {
        removeElement(file.controller.hiddenInput)
        return
      }

      if (self.hasExistingImageInputTarget) {
        self.existingImageInputTargets.forEach(inputTarget => {
          if (inputTarget.value == file.signed_id) {
            inputTarget.remove()
          }
        })
      }

    })

    this.dropZone.on("canceled", (file) => {
      file.controller && file.controller.xhr.abort()
    })

    this.dropZone.on("processing", (file) => {
      this.submitButton.disabled = true
    })

    this.dropZone.on("queuecomplete", (file) => {
      this.submitButton.disabled = false
    })

    this.dropZone.on("maxfilesexceeded", (file) => {
      this.submitButton.disabled = true
    })

    this.dropHereTarget.style.display = "block"
  }

  get headers() { return { "X-CSRF-Token": getMetaValue("csrf-token") } }

  get url() { return this.inputTarget.getAttribute("data-direct-upload-url") }

  get acceptedFiles() { return this.data.get("acceptedFiles") }

  get addRemoveLinks() { return this.data.get("addRemoveLinks") || true }

  get form() { return this.element.closest("form") }

  get submitButton() { return findElement(this.form, "input[type=submit], button[type=submit]") }

}

class DirectUploadManager {
  constructor(source, file) {
    this.directUpload = createDirectUpload(file, source.url, this)
    this.source = source
    this.file = file
  }

  start() {
    this.file.controller = this
    this.hiddenInput = this.createHiddenInput()
    this.directUpload.create((error, attributes) => {
      if (error) {
        removeElement(this.hiddenInput)
        this.emitDropzoneError(error)
      } else {
        this.hiddenInput.value = attributes.signed_id
        this.emitDropzoneSuccess()
      }
    })
  }

  // Private
  createHiddenInput() {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = this.source.inputTarget.name
    insertAfter(input, this.source.inputTarget)
    return input
  }

  directUploadWillStoreFileWithXHR(xhr) {
    this.emitDropzoneUploading()
  }

  emitDropzoneUploading() {
    this.file.status = Dropzone.UPLOADING
    this.source.dropZone.emit("processing", this.file)
  }

  emitDropzoneError(error) {
    this.file.status = Dropzone.ERROR
    this.source.dropZone.emit("error", this.file, error)
    this.source.dropZone.emit("complete", this.file)
  }

  emitDropzoneSuccess() {
    this.file.status = Dropzone.SUCCESS
    this.source.dropZone.emit("success", this.file)
    this.source.dropZone.emit("complete", this.file)
  }
}

// Top level...
function createDirectUploadManager(source, file) {
  return new DirectUploadManager(source, file)
}

function createDirectUpload(file, url, controller) {
  return new DirectUpload(file, url, controller)
}

function createDropZone(controller) {
  const previewNode = document.querySelector("#custom-preview-template");
  previewNode.id = "";
  const previewTemplate = previewNode.parentNode.innerHTML;
  previewNode.parentNode.removeChild(previewNode);

  return new Dropzone(controller.element, {
    url: controller.url,
    previewTemplate: previewTemplate,
    dictRemoveFile: "", // Override default text to only display trash icon
    headers: controller.headers,
    maxFiles: controller.maxFilesValue,
    maxFilesize: controller.maxFileSizeValue,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    autoQueue: false,
    init: function () {
      let myDropzone = this;
      controller.imagesValue.forEach(img => {
        let mockFile = img
        mockFile.accepted = true
        mockFile.status = Dropzone.SUCCESS
        myDropzone.displayExistingFile(mockFile, mockFile.url, () => {
          myDropzone.files.push(mockFile)
          myDropzone._updateMaxFilesReachedClass()
        })


      })
    }
  })
}
