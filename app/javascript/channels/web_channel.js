import consumer from "channels/consumer"
import $ from 'jquery'
import * as bootstrap from 'bootstrap'
window.$ = $
window.jQuery = $

$(function(){
  const deviceId = $("[data-device-id]").data("device-id")
  if(deviceId) {
    consumer.subscriptions.create({ channel: "WebChannel", device_id: deviceId }, {
      received(data) {
        console.log(data)
        window.progressModal && progressModal.hide()

        const refreshUrl = $("[data-refresh-action-url]").data("refresh-action-url");
        if(data.type === "device_is_active" ) {
          $.get(refreshUrl);
          beActiveStatus(deviceId);
          stopWatchdogOfPing();
        } else if (data.type === "booted" ) {
          // none
        } else if (data.type === "loaded_config" ) {
          window.location.reload();
        } else if (data.type === "completed_upgrade_pbm" ) {
          (new bootstrap.Toast(document.getElementById("ok-upgrade-toast"))).show();
          $.post($("[data-offline-action-url]").data("offline-action-url"));
          $.get(refreshUrl);
        } else if (data.type === "reload_config" ) {
          (new bootstrap.Toast(document.getElementById("ok-toast"))).show();
        } else if (data.type === "error_reload_config" ) {
          (new bootstrap.Toast(document.getElementById("ng-toast"))).show();
          $("#ng-toast-reason").text(data.reason);
        } else if (data.type === "start_reboot" ) {
          (new bootstrap.Toast(document.getElementById("reboot-toast"))).show();
          $.post($("[data-offline-action-url]").data("offline-action-url"));
          $.get(refreshUrl);
        } else {
          console.log("unknown type!!!!!")
        }
      },
    })
  }
})
