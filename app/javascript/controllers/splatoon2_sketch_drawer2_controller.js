import { Controller } from "@hotwired/stimulus"
import axios from 'axios';

class Status {
  constructor(element) {
    this.element = element
    this.running = false;
  }

  start() {
    this.element.innerText = "書き込み中";
    this.element.className = "badge bg-primary";
    this.running = true;
  }

  stop() {
    this.element.innerText = "停止中";
    this.element.className = "badge bg-secondary";
    this.running = false;
  }

  isRunning() {
    return this.running;
  }
}

class Timer {
  constructor(element) {
    this.label = element
    this.value = 0;
    this.reset();
  }

  start() {
    this.intervalTimerId = setInterval(this.incrementValue.bind(this), 1000)
  }

  stop() {
    clearTimeout(this.intervalTimerId);
  }

  reset() {
    this.value = 0;
    this.applyLabel()
  }

  incrementValue() {
    this.value = this.value + 1;
    this.applyLabel();
  }

  applyLabel() {
    this.label.innerText = `${this.value}秒`;
  }
}


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
    this.status = new Status(this.statusTarget);
    this.timer = new Timer(this.timerTarget);

    this.maxDataValueLength = this.dataValue.length
    this.dotsData = JSON.parse(JSON.stringify(this.dataValue));
    this._stop();
    this._updateProgress();
    this.lastRequest = { id: null, status: null };
    this.timer.reset();
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
    if(this.isRunning) { return }

    this.status.start();
    this.timer.start();
    this._updateProgress();
    const send_interval = Number(this.send_intervalTarget.value || 1000)
    this.intervalId = setInterval(this._sendMacro.bind(this), send_interval); // TODO 500以下の時は1000にする
  }

  _stop() {
    this._updateProgress();
    this.status.stop();
    this.timer.stop();
    clearTimeout(this.intervalId);
  }

  _reset() {
    this._updateProgress()
    this.dotsData = JSON.parse(JSON.stringify(this.dataValue));
    this._stop();
    this.timer.reset();
  }

  _sendMacro() {
    if(!this.isRunning) { return }
    this._updateProgress();

    if(this.dotsData.length == 0) {
      this._stop();
      return;
    }

    this._postRequest()
  }

  _postRequest() {
    const maxMacrosSize = 2000;
    const statusProcessed = "processed";
    const statusWait = "processed";

    // 前回にリクエストを送っていたら、それが完了するまで待機する
    if(this.lastRequest.id) {
      axios.get(`/api/pbm_jobs/${this.lastRequest.id}`).then((response) => {
        if(response.data.status === statusProcessed) { this.lastRequest.status = statusProcessed }

        if(this.lastRequest.status === statusWait) { 
          console.log("前回のリクエストが未完了なので何もしません");
          return;
        }

        // リクエストが成功したらthis.dotsDataから取り除く
        const macros = [...Array(maxMacrosSize)].map((x, index) => this.dotsData[index]);
        const postData = { macros: macros };
        axios.post(this.requestPathValue, postData).then((response) => {
          this.lastRequest.id = response.data.uuid
          this.lastRequest.status = statusWait
        }).then(() => {
          [...Array(maxMacrosSize)].map(() => this.dotsData.shift());
        })
      })
    } else {
      const macros = [...Array(maxMacrosSize)].map((x, index) => this.dotsData[index]);
      const postData = { macros: macros };
      axios.post(this.requestPathValue, postData).then((response) => {
        this.lastRequest.id = response.data.uuid
        this.lastRequest.status = statusWait
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
}
