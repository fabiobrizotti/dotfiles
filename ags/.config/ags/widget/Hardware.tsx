import { createComputed, With } from "ags"
import { Astal, Gtk } from "ags/gtk4"
import SystemMonitor from "../service/SystemMonitor"

export function Hardware() {
  const sys = SystemMonitor.get_default()
  const cpu = createComputed(() => Math.round(sys.cpuUsage * 100))
  const ram = createComputed(() => Math.round(sys.memUsage * 100))
  const temp = createComputed(() => Math.round(sys.temp))
  const disk = createComputed(() => Math.round(sys.diskUsage * 100))

  return (
    <box class="hardware" spacing={8}>
      <box class="hw-group" spacing={4}>
        <image iconName="cpu-symbolic" pixelSize={14} />
        <With value={cpu}>
          {(v) => <label label={`${v}%`} />}
        </With>
      </box>
      <box class="hw-group" spacing={4}>
        <image iconName="memory-symbolic" pixelSize={14} />
        <With value={ram}>
          {(v) => <label label={`${v}%`} />}
        </With>
      </box>
      <box class="hw-group" spacing={4}>
        <image iconName="temperature-symbolic" pixelSize={14} />
        <With value={temp}>
          {(v) => <label label={`${v}°`} />}
        </With>
      </box>
      <box class="hw-group" spacing={4}>
        <image iconName="drive-harddisk-symbolic" pixelSize={14} />
        <With value={disk}>
          {(v) => <label label={`${v}%`} />}
        </With>
      </box>
    </box>
  )
}