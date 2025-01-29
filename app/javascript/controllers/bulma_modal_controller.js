import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bulma-modal"
export default class extends Controller {
  static targets = ["root"]
  close() {
    this.rootTarget.classList.remove("is-active")
  }
}
