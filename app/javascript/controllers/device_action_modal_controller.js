import { Controller } from '@hotwired/stimulus';
import * as bootstrap from 'bootstrap';

// Connects to data-controller="device-action-modal"
export default class extends Controller {
  static targets = ['content'];
  static values = { pingUrl: String };

  open() {
    const onetimeModalElem = this._buildModalElement();
    new bootstrap.Modal(onetimeModalElem).show();

    fetch(this.pingUrlValue, { method: 'POST' });

    onetimeModalElem.addEventListener('hidden.bs.modal', function () {
      onetimeModalElem.remove();
    });
  }

  _buildModalElement() {
    const modalId = 'device-action-onetime-modal-id';
    const wrapperElement = document.createElement('div');
    wrapperElement.innerHTML = `
      <div class="modal fade" tabindex="-1" id="${modalId}">
        <div class="modal-dialog">
          <div class="modal-content">${this.contentTarget.innerHTML}</div>
        </div>
      </div>
    `;

    document.body.appendChild(wrapperElement);

    // NOTE: findしたelementじゃないとモーダルが表示されないのでfindする
    return document.getElementById(modalId);
  }
}
