import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "display", "progressBar", "label", "trigger"]
  static values = { seconds: Number, total: Number }

  connect() {
    this.interval = null
  }

  disconnect() {
    this.clearTimer()
  }

  triggerTargetConnected(element) {
    const restSeconds = parseInt(element.dataset.restSeconds, 10)
    if (!restSeconds || restSeconds <= 0) return

    this.startTimer(restSeconds)
  }

  startTimer(restSeconds) {
    this.clearTimer()
    this.totalValue = restSeconds
    this.secondsValue = restSeconds

    this.containerTarget.hidden = false
    this.labelTarget.textContent = "Rest"
    this.labelTarget.classList.remove("text-green-400")
    this.labelTarget.classList.add("text-gray-300")
    this.progressBarTarget.classList.remove("bg-green-500")
    this.progressBarTarget.classList.add("bg-blue-500")
    this.updateDisplay()

    this.interval = setInterval(() => this.tick(), 1000)
  }

  tick() {
    this.secondsValue--
    this.updateDisplay()

    if (this.secondsValue <= 0) {
      this.complete()
    }
  }

  complete() {
    this.clearTimer()
    this.displayTarget.textContent = "Go!"
    this.labelTarget.textContent = "Rest complete"
    this.labelTarget.classList.remove("text-gray-300")
    this.labelTarget.classList.add("text-green-400")
    this.progressBarTarget.style.width = "100%"
    this.progressBarTarget.classList.remove("bg-blue-500")
    this.progressBarTarget.classList.add("bg-green-500")

    if (navigator.vibrate) {
      navigator.vibrate([200, 100, 200])
    }
  }

  skip() {
    this.clearTimer()
    this.containerTarget.hidden = true
  }

  updateDisplay() {
    const mins = Math.floor(this.secondsValue / 60)
    const secs = this.secondsValue % 60
    this.displayTarget.textContent = `${mins}:${secs.toString().padStart(2, "0")}`

    const pct = this.totalValue > 0 ? (this.secondsValue / this.totalValue) * 100 : 0
    this.progressBarTarget.style.width = `${pct}%`
  }

  clearTimer() {
    if (this.interval) {
      clearInterval(this.interval)
      this.interval = null
    }
  }
}
