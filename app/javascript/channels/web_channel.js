import consumer from "./consumer"

$(function(){
  const deviceId = $("[data-device-id]").data("device-id")
  if(deviceId) {
    consumer.subscriptions.create({ channel: "WebChannel", device_id: deviceId }, {
      received(data) {
        console.log(data)

        if(data.type === "device_is_active" ) {
          const refreshUrl = $("[data-refresh-page-url]").data("refresh-page-url")
          $.get(refreshUrl);
          beActiveStatus(deviceId);
          stopWatchdogOfPing();
        } else if (data.type === "reload_config" ) {
          $("#ok-toast").toast("show");
        } else if (data.type === "failed_to_reload_config" ) {
          $("#ng-toast").toast("show");
        } else {
          console.log("unknown type!!!!!")
        }
      },
    })
  }
})
