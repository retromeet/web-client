import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

// Connects to data-controller="bulma-modal"
export default class extends Controller {
  static targets = ["root", "content"]
  static outlets = ["bulma-modal"]
  connect() {
    if (this.hasBulmaModalOutlet) {
      for (const bulmaModal of this.bulmaModalOutlets) {
        if (bulmaModal == this) {
          continue
        }
        bulmaModal.close()
      }
    }
    useClickOutside(this, { element: this.contentTarget })
  }
  modalClose() {
    this.rootTarget.classList.remove("is-active")
  }
  close() {
    if (this.rootTarget.classList.contains("removable")) {
      this.remove();
    } else {
      this.modalClose();
    }
  }
  clickOutside(event) {
    this.close()
  }
  remove() {
    this.rootTarget.remove()
  }
}
