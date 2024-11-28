import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["output", "input", "filename", "parentdiv"];
  read_url() {
    var input = this.inputTarget;
    var output = this.outputTarget;
    var filename = this.filenameTarget;
    var parentdiv = this.parentdivTarget;

    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function () {
        output.src = reader.result;
      }

      reader.readAsDataURL(input.files[0]);
      filename.innerHTML = input.files[0].name;
      parentdiv.classList.remove("is-empty")
    }
  }
}
