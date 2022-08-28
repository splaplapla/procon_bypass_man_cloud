import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

// Connects to data-controller="splatoon2-sketches"
export default class extends Controller {
  connect() {
    const imagePath = this.data.get('imagePathValue');
    this.imageElement = this.element;
    axios.get(imagePath).then(this._processResponse.bind(this));
  }

  _processResponse(response) {
    this.imageElement.src = `data:${response.data.image_data}`;
  }
}
