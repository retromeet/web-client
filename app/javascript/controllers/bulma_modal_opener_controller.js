import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bulma-modal-opener"
export default class extends Controller {
  static outlets = [ "bulma-modal" ]
  open() {
    this.bulmaModalOutletElement.classList.add("is-active")
  }
}
