import { createBinding, createComputed, With } from "ags"
import { execAsync } from "ags/process"
import { Astal, Gtk } from "ags/gtk4"
import AstalBrightness from "gi://AstalBrightness"

export function Brightness() {
  const scr = AstalBrightness.get_default()
  const brightness = createBinding(scr.screen, "brightness")
  const icon = "display-brightness-symbolic"
  const pct = createComputed(() => `${Math.round(brightness.get() * 100)}%`)

  return (
    <button
      class="backlight"
      onClicked={() => execAsync("brightnessctl set 10%-")}
      tooltipText={pct}
    >
      <box spacing={4}>
        <image iconName={icon} pixelSize={16} />
        <With value={brightness}>
          {(b) => (b > 0 ? <label label={pct} /> : <label />)}
        </With>
      </box>
    </button>
  )
}