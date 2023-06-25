import { Controller } from '@hotwired/stimulus';

// 時間的凝集
// Connects to data-controller="device-onload"
export default class extends Controller {
  static values = { pingUrl: String, pbmVersionUrl: String };

  connect() {
    this.pingDevice();
    this.getDevicePbmVersion();
  }

  pingDevice() {
    if (this.hasPingUrlValue) {
      let url = this.pingUrlValue;
      fetch(url, { method: 'POST' });
    }
  }

  getDevicePbmVersion() {
    if (this.hasPbmVersionUrlValue) {
      let url = this.pbmVersionUrlValue;
      fetch(url);
    }
  }
}
