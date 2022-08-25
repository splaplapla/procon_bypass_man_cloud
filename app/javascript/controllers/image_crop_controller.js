import { Controller } from "@hotwired/stimulus"
import Cropper from 'cropperjs';

// Connects to data-controller="image-crop"
export default class extends Controller {
  static values = {
    cropData: Object,
  }

  static targets = [
    'crop_data',
    'form',
  ]


  connect() {
    const sketchImage = document.getElementById('sketch-image');
    const cvs = document.getElementById('image-canvas');
    const ctx = cvs.getContext('2d');

    const img = new Image();
    img.src = sketchImage.src;
    cvs.width = img.width;
    cvs.height = img.height;

    const onload = function(instance) {
      ctx.drawImage(img, 0, 0);
      instance.cropperValue = new Cropper(cvs, {
        zoomable: false,
        aspectRatio: 320 / 120,
        center: true,
        dragMode: "none",
        minCropBoxWidth: 320,
        minCropBoxHeight: 120,
        ready() {
          instance.cropperValue.setCropBoxData(instance.cropDataValue)
        },
      })
    };
    img.onload = onload(this)
  }

  submit(event) {
    event.preventDefault();
    this.crop_dataTarget.value = JSON.stringify(this.cropperValue.getCropBoxData());
    this.formTarget.submit();
  }
}
