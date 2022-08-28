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

class ProgressLabel {
  constructor(progressElement, positionElement, maxDataLength) {
    this.progressElement = progressElement;
    this.positionElement = positionElement;
    this.maxDataLength = maxDataLength;
  }

  update(leftDataLength) {
    const leftDotsLength = this.maxDataLength - leftDataLength;
    this.progressElement.innerText = `${Math.trunc((leftDotsLength / this.maxDataLength) * 100)}%`;
    this.positionElement.innerText = `${leftDotsLength} / ${this.maxDataLength}`;
  }
}

class LastRequest {
  static statusProcessed = "processed";
  static statusWait = "wait";

  constructor() {
    this.reset();
  }

  // @return [void]
  reset() {
    this.request = { id: null, status: null };
  }

  // @return [Booolean]
  isStatusWait() {
    return this.request.status === LastRequest.statusWait;
  }

  // @return [String]
  id(){ return this.request.id }

  // @return [void]
  beStatusProcessed() {
    this.request.status = LastRequest.statusProcessed;
  }

  // @return [void]
  beStatusWait() {
    this.request.status = LastRequest.statusWait;
  }

  // @return [void]
  setId(id) {
    this.request.id = id
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
    this.progressLabel = new ProgressLabel(this.progressTarget, this.positionTarget, this.dataValue.length);
    this.lastRequest = new LastRequest()

    this.maxDataValueLength = this.dataValue.length;
    this.dotsData = JSON.parse(JSON.stringify(this.dataValue));
    this._stop();
    this.progressLabel.update(this.dotsData.length);
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
    this.lastRequestStatus.reset();
  }

  _start() {
    if(this.status.isRunning()) { return }

    this.status.start();
    this.timer.start();
    this.progressLabel.update(this.dotsData.length);

    const send_interval = Number(this.send_intervalTarget.value || 1000)
    this.intervalId = setInterval(this._sendMacro.bind(this), send_interval); // TODO 500以下の時は1000にする
  }

  _stop() {
    this.progressLabel.update(this.dotsData.length);
    this.status.stop();
    this.timer.stop();
    clearTimeout(this.intervalId);
  }

  _reset() {
    this.progressLabel.update(this.dotsData.length);
    this.dotsData = JSON.parse(JSON.stringify(this.dataValue));
    this._stop();
    this.timer.reset();
  }

  _sendMacro() {
    if(!this.status.isRunning()) { return }
    this.progressLabel.update(this.dotsData.length);

    if(this.dotsData.length == 0) {
      this._stop();
      return;
    }

    this._postRequest();
  }

  _postRequest() {
    const maxMacrosSize = 2000;

    // 前回にリクエストを送っていたら、それが完了するまで待機する
    if(this.lastRequest.id()) {
      axios.get(`/api/pbm_jobs/${this.lastRequest.id()}`).then((response) => {
        if(response.data.status === LastRequest.statusProcessed) {
          this.lastRequest.beStatusProcessed();
        }

        if(this.lastRequest.isStatusWait()) {
          console.log("前回のリクエストが未完了なので何もしません");
          return;
        }

        // リクエストが成功したらthis.dotsDataから取り除く
        const macros = [...Array(maxMacrosSize)].map((x, index) => this.dotsData[index]);
        const postData = { macros: macros };
        axios.post(this.requestPathValue, postData).then((response) => {
          this.lastRequest.setId(response.data.uuid);
          this.lastRequest.beStatusWait();
        }).then(() => {
          [...Array(maxMacrosSize)].map(() => this.dotsData.shift());
        })
      })
    } else {
      const macros = [...Array(maxMacrosSize)].map((x, index) => this.dotsData[index]);
      const postData = { macros: macros };
      axios.post(this.requestPathValue, postData).then((response) => {
        this.lastRequest.setId(response.data.uuid);
        this.lastRequest.beStatusWait();
      }).then(() => {
        [...Array(maxMacrosSize)].map(() => this.dotsData.shift());
      })
    }
  }
}
