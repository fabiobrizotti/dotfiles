import { createBinding, createComputed, With } from "ags"
import { Astal, Gtk } from "ags/gtk4"
import AstalNotifd from "gi://AstalNotifd"

export function Notifications() {
  const notifd = AstalNotifd.get_default()
  const count = createBinding(notifd, "notifications").as((n) => n.length)
  const dnd = createBinding(notifd, "dont_disturb")

  const icon = createComputed(() =>
    dnd.get() ? "notifications-disabled-symbolic" : "stock_bell",
  )
  const cls = createComputed(() =>
    dnd.get() ? "notifications dnd" : "notifications",
  )

  return (
    <button
      class={cls}
      tooltipText="Notificações"
      onClicked={() => {
        notifd.dont_disturb = !notifd.dont_disturb
      }}
    >
      <box spacing={4}>
        <image iconName={icon} pixelSize={15} />
        <With value={count}>
          {(c) => c > 0 && <label class="count" label={`${c}`} />}
        </With>
      </box>
    </button>
  )
}