import { Controller } from "@hotwired/stimulus"
import axios from 'axios';

// Connects to data-controller="splatoon2-sketch-binary-threshold-previewer"
export default class extends Controller {
  static values = {
    imagePath: String,
  }

  static targets = [
    "slider",
    "image",
  ]

  connect() {
    this.preview();
  }

  preview() {
    this.imageTarget.src = "data:image/jpeg;base64,R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAAIf8LSW1hZ2VNYWdpY2sOZ2Ft\nbWE9MC40NTQ1NDUALAAAAAABAAEAAAICRAEAOw==" // 無の画像を入れる
    this._onSpinner();

    axios.get(this._requestPath()).
      then(this._processResponse.bind(this)).
      catch((err) => {
        console.log(err);
      })
  }

  _processResponse(response) {
    this.imageTarget.src = `data:${response.data.image_data}`
    this._offSpinner();
  }

  _onSpinner() {
    this.imageTarget.className = "spinner";
  }

  _offSpinner() {
    this.imageTarget.className = "";
  }

  _requestPath() {
    const sliderValue = this.sliderTarget.value;
    const requestPath = this.imagePathValue;
    return `${requestPath}?binary_threshold=${sliderValue}`;
  }
}
