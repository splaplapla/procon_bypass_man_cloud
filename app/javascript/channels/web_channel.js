import consumer from "./consumer"

$(function(){
  const deviceId = $("[data-device-id]").data("device-id")
  if(deviceId) {
    consumer.subscriptions.create({ channel: "WebChannel", device_id: deviceId }, {
      received(data) {
        console.log(data)
        $('#progress-modal').modal("hide");

        const refreshUrl = $("[data-refresh-action-url]").data("refresh-action-url");
        if(data.type === "device_is_active" ) {
          $.get(refreshUrl);
          beActiveStatus(deviceId);
          stopWatchdogOfPing();
        } else if (data.type === "completed_upgrade_pbm" ) {
          $("#ok-upgrade-toast").toast("show");
          $.post($("[data-offline-action-url]").data("offline-action-url"));
          $.get(refreshUrl);
        } else if (data.type === "reload_config" ) {
          $("#ok-toast").toast("show");
        } else if (data.type === "error_reload_config" ) {
          $("#ng-toast").toast("show");
          $("#ng-toast-reason").text(data.reason);
        } else if (data.type === "start_reboot" ) {
          $("#reboot-toast").toast("show");
          $.post($("[data-offline-action-url]").data("offline-action-url"));
          $.get(refreshUrl);
        } else {
          console.log("unknown type!!!!!")
        }
      },
    })
  }
})
