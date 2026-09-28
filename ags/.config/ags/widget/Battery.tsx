import { createBinding, createComputed } from "ags"
import { Astal, Gtk } from "ags/gtk4"
import AstalBattery from "gi://AstalBattery"

export function Battery() {
  const battery = AstalBattery.get_default()
  const charging = createBinding(battery, "charging")
  const pct = createBinding(battery, "percentage")
  const isPresent = createBinding(battery, "is_present")

  const icon = createComputed(() => {
    const p = Math.floor(pct.get() * 100)
    const chunk = Math.floor(p / 10) * 10
    const charge = charging.get() ? "charging" : ""
    return `battery-level-${chunk}${charge}-symbolic`
  })
  const label = createComputed(() => `${Math.floor(pct.get() * 100)}%`)

  const cls = createComputed(() => {
    let c = "battery"
    if (charging.get()) c += " charging"
    else if ((pct.get() || 0) < 0.2) c += " critical"
    return c
  })

  return (
    <box class={cls} visible={isPresent} spacing={4} tooltipText={label}>
      <image iconName={icon} pixelSize={15} />
      <label label={label} visible={!charging} />
    </box>
  )
}