import { Controller } from "@hotwired/stimulus"
import axios from 'axios';

// Connects to data-controller="splatoon2-sketch-drawer"
export default class extends Controller {
  static values = {
    data: Array,
    request_path: String,
  }

  static targets = [
    "status",
  ]

  connect() {
    this.dataValue;
    this._stop(this);
    this.macroPointerX = 0;
    this.macroPointerY = 0;
  }

  // @public
  start() {
    this._start(this);
  }

  // @public
  stop() {
    this._stop(this);
  }

  // @public
  reset() {
    this._reset(this);
  }

  _sendMacro() {
    const macros = this.dataValue[this.macroPointerY][this.macroPointerX];
    if(!macros) { this.macroPointerY++; return; };
    this._postRequest(macros)
    this.macroPointerX++;
  }

  _start() {
    this.runStats = true;
    this.statusTarget.innerText = "書き込み中";
    this.statusTarget.className = "badge bg-primary";
    this.intervalId = setInterval(this._sendMacro.bind(this), 500);
  }

  _stop() {
    this.runStats = false;
    this.statusTarget.innerText = "停止中";
    this.statusTarget.className = "badge bg-secondary";
    clearTimeout(this.intervalId);
  }

  _reset() {
    this.macroPointerX = 0;
    this.macroPointerY = 0;
    this._stop();
  }

  _postRequest(macros) {
    const postData = { macros: macros };
    axios.post(this.requestPathValue, postData).then((response) => {
      console.log(response);
    })
  }
}
