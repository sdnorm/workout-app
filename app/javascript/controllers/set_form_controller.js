import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["weight"]

  connect() {
    // Auto-focus weight field on connect
    this.element.addEventListener("turbo:submit-end", (event) => {
      if (event.detail.success) {
        this.element.reset()
        if (this.hasWeightTarget) {
          this.weightTarget.focus()
        }
      }
    })
  }
}
