import { createBinding, createComputed, With } from "ags"
import { execAsync } from "ags/process"
import { Astal, Gtk } from "ags/gtk4"
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
  const text = createComputed(() =>
    title.get() && artist.get() ? `${title.get()} · ${artist.get()}` : title.get(),
  )

  return (
    <button
      class={cls}
      visible={title.as((t) => !!t)}
      onClicked={() => execAsync('playerctl play-pause')}
    >
      <box spacing={6}>
        <image iconName="media-playback-start-symbolic" pixelSize={12} />
        <label label={text} maxWidthChars={42} ellipsize="end" />
      </box>
    </button>
  )
}