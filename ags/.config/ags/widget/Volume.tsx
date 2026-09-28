import { createBinding, createComputed, With } from "ags"
import { execAsync } from "ags/process"
import { Astal, Gtk } from "ags/gtk4"
import AstalWp from "gi://AstalWp"

export function Volume() {
  const wp = AstalWp.get_default()
  const speaker = createBinding(wp.audio, "default_speaker")
  const vol = createComputed(
    () => Math.round((speaker.get()?.volume || 0) * 100) + "%",
  )
  const muted = createComputed(() => speaker.get()?.isMuted || false)

  const icon = createComputed(() => {
    const m = muted.get()
    const v = speaker.get()?.volume || 0
    if (m) return "audio-volume-muted-symbolic"
    if (v <= 0.33) return "audio-volume-low-symbolic"
    if (v <= 0.66) return "audio-volume-medium-symbolic"
    return "audio-volume-high-symbolic"
  })

  return (
    <button
      class="volume"
      onClicked={() => execAsync("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")}
      tooltipText={vol}
    >
      <box spacing={4}>
        <With value={icon}>
          {(name) => <image iconName={name} pixelSize={16} />}
        </With>
        <With value={muted}>
          {(m) => !m && <label label={vol} />}
        </With>
      </box>
    </button>
  )
}