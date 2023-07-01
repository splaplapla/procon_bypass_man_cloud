import { Controller } from '@hotwired/stimulus';
import * as bootstrap from 'bootstrap';

// Connects to data-controller="device-toast"
export default class extends Controller {
  connect() {
    this.toastNode = this.element;
  }

  openToast() {
    new bootstrap.Toast(this.toastNode, { delay: 5000 }).show();
  }
}
