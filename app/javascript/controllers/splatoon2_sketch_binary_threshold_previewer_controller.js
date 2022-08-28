import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

class PreviewImage {
  constructor(imgElement) {
    this.imgElement = imgElement;
  }

  startSpinner() {
    this.imgElement.src =
      'data:image/jpeg;base64,R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAAIf8LSW1hZ2VNYWdpY2sOZ2Ft\nbWE9MC40NTQ1NDUALAAAAAABAAEAAAICRAEAOw=='; // 無の画像を入れる
    this.imgElement.className = 'spinner';
  }

  writeImage(imgSrc) {
    this.imgElement.src = imgSrc;
  }

  stopSpinner() {
    this.imgElement.className = '';
  }
}

// Connects to data-controller="splatoon2-sketch-binary-threshold-previewer"
export default class extends Controller {
  static values = {
    imagePath: String,
  };

  static targets = ['slider', 'image'];

  connect() {
    this.previewImage = new PreviewImage(this.imageTarget);
    this.preview();
  }

  preview() {
    this.previewImage.startSpinner();

    axios
      .get(this._requestPath())
      .then(this._processResponse.bind(this))
      .catch((err) => {
        console.log(err);
      });
  }

  _processResponse(response) {
    this.previewImage.writeImage(`data:${response.data.image_data}`);
    this.previewImage.stopSpinner();
  }

  _requestPath() {
    const sliderValue = this.sliderTarget.value;
    const requestPath = this.imagePathValue;
    return `${requestPath}?binary_threshold=${sliderValue}`;
  }
}
