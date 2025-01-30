import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

// Connects to data-controller="bulma-modal"
export default class extends Controller {
  static targets = ["root", "content"]
  connect() {
    useClickOutside(this, { element: this.contentTarget })
  }
  modalClose() {
    this.rootTarget.classList.remove("is-active")
  }
  close() {
    this.modalClose()
  }
  clickOutside(event) {
    this.modalClose()
  }
}
