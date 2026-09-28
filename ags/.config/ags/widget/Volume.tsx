import { createBinding, createComputed, With } from "ags"
import { Astal, Gtk } from "ags/gtk4"
import AstalWp from "gi://AstalWp"

export function Volume() {
  const wp = AstalWp.get_default()
  const speaker = createBinding(wp.audio, "default_speaker")
  const vol = createComputed(
    () => Math.round((speaker.get()?.volume || 0) * 100) + "%",
  )
  const muted = createComputed(() => speaker.get()?.mute || false)

  const icon = createComputed(() => {
    const m = muted.get()
    const v = speaker.get()?.volume || 0
    if (m) return "audio-volume-muted-symbolic"
    if (v <= 0.33) return "audio-volume-low-symbolic"
    if (v <= 0.66) return "audio-volume-medium-symbolic"
    return "audio-volume-high-symbolic"
  })

  const cls = createComputed(() =>
    muted.get() ? "volume muted" : "volume",
  )

  return (
    <button
      class={cls}
      onClicked={() => speaker.get()?.set_mute(!muted.get())}
      tooltipText={vol}
    >
      <box spacing={4}>
        <With value={icon}>
          {(name) => <image iconName={name} pixelSize={15} />}
        </With>
        <With value={muted}>
          {(m) => !m && <label label={vol} />}
        </With>
      </box>
      <Gtk.EventControllerScroll
        onScroll={(_ctrl, _dx, dy) => {
          const spk = speaker.get()
          if (!spk) return
          const step = dy > 0 ? 0.05 : -0.05
          const v = Math.min(1, Math.max(0, (spk.volume || 0) + step))
          spk.set_volume(v)
          if (v > 0 && spk.mute) spk.set_mute(false)
        }}
      />
    </button>
  )
}