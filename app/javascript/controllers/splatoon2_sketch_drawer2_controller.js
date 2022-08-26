import { Controller } from "@hotwired/stimulus"
import axios from 'axios';

// Connects to data-controller="splatoon2-sketch-drawer2"
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
    "timer",
  ]

  connect() {
    this._setTimer();
    this.maxDataValueLength = this.dataValue.length
    this.dotsData = JSON.parse(JSON.stringify(this.dataValue));
    this._stop();
    this._updateProgress();
    this.lastRequest = { id: null, status: null };
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

  _start() {
    this.startAt = Date.now();
    this._updateProgress();
    this.runStats = true;
    this.statusTarget.innerText = "書き込み中";
    this.statusTarget.className = "badge bg-primary";
    const send_interval = Number(this.send_intervalTarget.value || 1000)
    this.intervalId = setInterval(this._sendMacro.bind(this), send_interval); // TODO 500以下の時は1000にする
  }

  _stop() {
    this._updateProgress();
    this.runStats = false;
    this.statusTarget.innerText = "停止中";
    this.statusTarget.className = "badge bg-secondary";
    clearTimeout(this.intervalId);
  }

  _reset() {
    this.startAt = Date.now();
    this.macroPointer = 0;
    this._updateProgress()
    this.dotsData = JSON.parse(JSON.stringify(this.dataValue));
    this._stop();
    this._setTimer();
  }

  _sendMacro() {
    this._setTimer();

    if(!this.runStats) { return }
    this._updateProgress();

    if(this.dotsData.length == 0) { // 全部描き切った時
      this._stop();
      return;
    }

    this._postRequest()
  }

  _postRequest() {
    const maxMacrosSize = 1000;

    // 前回にリクエストを送っていたら、完了するまで
    if(this.lastRequest.id) {
      axios.get(`/api/pbm_jobs/${this.lastRequest.id}`).then((response) => {
        if(response.data.status === "processed") { this.lastRequest.status = "processed" }

        if(this.lastRequest.status === "wait") { 
          console.log("前回のリクエストが未完了なので何もしません");
          return;
        }

        // リクエストが成功したらthis.dotsDataから取り除く
        const macros = [...Array(maxMacrosSize)].map((x, index) => this.dotsData[index]);
        const postData = { macros: macros };
        axios.post(this.requestPathValue, postData).then((response) => {
          this.lastRequest.id = response.data.uuid
          this.lastRequest.status = "wait"
        }).then(() => {
          [...Array(maxMacrosSize)].map(() => this.dotsData.shift());
        })
      })
    } else {
      const macros = [...Array(maxMacrosSize)].map((x, index) => this.dotsData[index]);
      const postData = { macros: macros };
      axios.post(this.requestPathValue, postData).then((response) => {
        this.lastRequest.id = response.data.uuid
        this.lastRequest.status = "wait"
      }).then(() => {
        [...Array(maxMacrosSize)].map(() => this.dotsData.shift());
      })
    }
  }

  _updateProgress() {
    this.positionTarget.innerText = `${this._leftDotsLength()} / ${this._maxDotsLength()}`;
    this.progressTarget.innerText = `${Math.trunc((this._leftDotsLength() / this._maxDotsLength()) * 100)}%`;
  }

  _leftDotsLength() {
    return this._maxDotsLength() - this.dotsData.length;
  }

  _maxDotsLength() {
    return this.maxDataValueLength;
  }

  _setTimer() {
    this.timerTarget.innerText = `${Math.trunc((Date.now() - this.startAt || 0) / 1000)}秒`;
  }
}
