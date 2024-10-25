import { Controller } from "@hotwired/stimulus"
import Choices from 'choices.js'
// Connects to data-controller="profile"
export default class extends Controller {
  static targets = ["languageSelect"];
  connect() {
    // TODO: check why it's connecting multiple times, maybe connect on TargetConnected, but can't seem to make it work
    new Choices(this.element,
      {
        removeItems: true, removeItemButton: true, maxItemCount: 5,
        classNames: {
          input: 'input',
          list: ['tags'],
          button: ['delete', 'is-small'],
          item: ['tag', 'is-medium']
        },
        removeItemIconText: "",
      }
    )
  }
}
