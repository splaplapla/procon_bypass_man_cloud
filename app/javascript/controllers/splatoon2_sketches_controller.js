import { Controller } from "@hotwired/stimulus"
import axios from 'axios';

// Connects to data-controller="splatoon2-sketches"
export default class extends Controller {
  connect() {
    console.log('ahj')
    // TODO window経由を止める
    window.imageElement = this.element;

    const path = this.data.get('imagePathValue')
    axios.get(path).then((response) => {
      window.imageElement.src = `data:${response.data.image_data}`
    })
  }
}
