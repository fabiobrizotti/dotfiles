import { createBinding, createComputed } from "ags"
import { execAsync } from "ags/process"
import { Astal, Gtk } from "ags/gtk4"
import AstalNetwork from "gi://AstalNetwork"

export function Network() {
  const net = AstalNetwork.get_default()
  const wifi = createBinding(net, "wifi")
  const wired = createBinding(net, "wired")

  const icon = createComputed(() => {
    if (wifi.get()?.internet === AstalNetwork.Internet.CONNECTED)
      return "network-wireless-signal-excellent-symbolic"
    if (wired.get()?.internet === AstalNetwork.Internet.CONNECTED)
      return "network-wired-symbolic"
    return "network-wireless-offline-symbolic"
  })
  const label = createComputed(() => {
    if (wifi.get()?.ssid) return wifi.get().ssid
    if (wired.get()?.internet === AstalNetwork.Internet.CONNECTED) return "eth"
    return "offline"
  })

  return (
    <button
      class="network"
      onClicked={() => execAsync("impala")}
      tooltipText={label}
    >
      <box spacing={4}>
        <image iconName={icon} pixelSize={16} />
        <label label={label} />
      </box>
    </button>
  )
}