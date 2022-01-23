import consumer from "./consumer"

$(function(){
  const deviceId = $("[data-device-id]").data("device-id")
  if(deviceId) {
    consumer.subscriptions.create({ channel: "WebChannel", device_id: deviceId }, {
      received(data) {
        console.log(data)
        const refreshUrl = $("[data-refresh-page-url]").data("refresh-page-url")
        $.get(refreshUrl);
        beActiveStatus(deviceId);
      },
    })
  }
})
