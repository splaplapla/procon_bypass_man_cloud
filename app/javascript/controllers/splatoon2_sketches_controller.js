import { Controller } from "@hotwired/stimulus"
import axios from 'axios';

// Connects to data-controller="splatoon2-sketches"
export default class extends Controller {
  connect() {
    // TODO window経由を止める
    const path = this.data.get('imagePathValue')
    if(!window.imageElements) { window.imageElements = {} }
    window.imageElements[path] = this.element;

    axios.get(path).then((response) => {
      window.imageElements[path].src = `data:${response.data.image_data}`
    })
  }
}
