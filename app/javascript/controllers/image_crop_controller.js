import { Controller } from "@hotwired/stimulus"
import Cropper from 'cropperjs';

// Connects to data-controller="image-crop"
export default class extends Controller {
  connect() {
    this.image = document.getElementById('image');

    //2Dコンテキストのオブジェクトを生成する
    const cvs = document.getElementById('image-canvas');
    const ctx = cvs.getContext('2d');

    //画像オブジェクトを生成
    var img = new Image();
    img.src = this.image.src;
    cvs.width = img.width;
    cvs.height = img.height;

    //画像をcanvasに設定
    img.onload = function(){
      ctx.drawImage(img, 0, 0);
      self.cropper = new Cropper(cvs, {
        zoomable: false,
        aspectRatio: 320/120,
        center: true,
        dragMode: "none",
        minCropBoxWidth: 320,
        minCropBoxHeight: 120,
      })
    }
  }
}
