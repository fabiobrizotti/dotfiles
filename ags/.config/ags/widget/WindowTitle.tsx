import { createBinding } from "ags"
import { Astal, Gtk } from "ags/gtk4"
import Pango from "gi://Pango"
import AstalHyprland from "gi://AstalHyprland"

export function WindowTitle() {
  const hypr = AstalHyprland.get_default()
  const title = createBinding(hypr, "focused-client").as((c) => c?.title || "")

  return (
    <label
      class="window-title"
      visible={title.as((t) => !!t)}
      label={title}
      maxWidthChars={38}
      ellipsize={Pango.EllipsizeMode.END}
    />
  )
}