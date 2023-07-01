import consumer from "channels/consumer"
import $ from 'jquery'
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
          document.getElementById("ok-upgrade-toast").click();
          $.post($("[data-offline-action-url]").data("offline-action-url"));
          $.get(refreshUrl);
        } else if (data.type === "reload_config" ) {
          document.getElementById("ok-toast").click();
        } else if (data.type === "error_reload_config" ) {
          document.getElementById("ng-toast").click();
          $("#ng-toast-reason").text(data.reason);
        } else if (data.type === "start_reboot" ) {
          document.getElementById("reboot-toast").click();
          $.post($("[data-offline-action-url]").data("offline-action-url"));
          $.get(refreshUrl);
        } else {
          console.log("unknown type!!!!!")
        }
      },
    })
  }
})
