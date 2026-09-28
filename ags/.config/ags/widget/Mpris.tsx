import { createBinding, createComputed, With } from "ags"
import { Astal, Gtk } from "ags/gtk4"
import Pango from "gi://Pango"
import AstalMpris from "gi://AstalMpris"

export function Mpris() {
  const mpris = AstalMpris.get_default()
  const player = createBinding(mpris, "players").as((ps) => ps[0])
  const playing = createComputed(() => player.get()?.playing || false)
  const title = createComputed(() => player.get()?.title || "")
  const artist = createComputed(() => player.get()?.artist || "")

  const cls = createComputed(() =>
    playing.get() ? "mpris playing" : "mpris",
  )
  const text = createComputed(() => {
    const t = title.get()
    const a = artist.get()
    if (t && a) return `${a} - ${t}`
    return t
  })

  return (
    <button
      class={cls}
      visible={title.as((t) => !!t)}
      onClicked={() => player.get()?.play_pause()}
    >
      <box spacing={6}>
        <image iconName="media-playback-start-symbolic" pixelSize={12} />
        <label
          label={text}
          maxWidthChars={42}
          ellipsize={Pango.EllipsizeMode.END}
        />
      </box>
    </button>
  )
}