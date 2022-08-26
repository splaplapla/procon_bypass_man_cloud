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
    "position",
    "progress",
    "send_interval",
  ]

  connect() {
    this._stop();
    this.macroPointerX = 0;
    this.macroPointerY = 0;
    this._writePosition();
    this._calcProgress();
  }

  // @public
  start() {
    this._start();
  }

  // @public
  stop() {
    this._stop();
  }

  // @public
  reset() {
    this._reset();
  }

  _sendMacro() {
    this._calcProgress();
    if(!this.runStats) { return }
    this._writePosition();

    if(!this.dataValue[this.macroPointerY]) { // 全部描き切った時
      this._stop();
      return;
    }

    const macros = this.dataValue[this.macroPointerY][this.macroPointerX];
    if(!macros) {
      this.macroPointerY++;
      this.macroPointerX = 0;
      return;
    };

    this._postRequest(macros)
    this.macroPointerX++;
  }

  _start() {
    this.runStats = true;
    this._calcProgress()
    this.statusTarget.innerText = "書き込み中";
    this.statusTarget.className = "badge bg-primary";
    const send_interval = Number(this.send_intervalTarget.value || 1000)
    this.intervalId = setInterval(this._sendMacro.bind(this), send_interval); // TODO 500以下の時は1000にする
  }

  _stop() {
    this._calcProgress();
    this.runStats = false;
    this.statusTarget.innerText = "停止中";
    this.statusTarget.className = "badge bg-secondary";
    clearTimeout(this.intervalId);
  }

  _reset() {
    this._calcProgress();
    this.macroPointerX = 0;
    this.macroPointerY = 0;
    this._writePosition();
    this._stop();
  }

  // TODO 500が返ってきたら停止する
  // TODO レスポンスが返ってくるまでは次のリクエストを送信しない
  _postRequest(macros) {
    const postData = { macros: macros };
    axios.post(this.requestPathValue, postData).then((response) => {
      console.log(response);
    })
  }

  _writePosition() {
    this.positionTarget.innerText = `${this.macroPointerY}x${this.macroPointerX}`;
  }

  _calcProgress() {
    this.progressTarget.innerText = `${Math.trunc((this.macroPointerY / this.dataValue.length) * 100)}%`;
  }
}
