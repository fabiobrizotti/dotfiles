import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { Workspaces } from "./Workspaces"
import { Clock } from "./Clock"
import { Battery } from "./Battery"
import { Network } from "./Network"
import { Volume } from "./Volume"
import { Brightness } from "./Brightness"
import { Mpris } from "./Mpris"
import { Tray } from "./Tray"
import { Hardware } from "./Hardware"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      name="bar"
      class="Bar"
      visible
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox class="bar-pill">
        <box class="modules start" $type="start" spacing={8}>
          <Mpris />
        </box>
        <box class="modules center" $type="center" halign={Gtk.Align.CENTER}>
          <Workspaces />
        </box>
        <box class="modules end" $type="end" spacing={8} halign={Gtk.Align.END}>
          <Hardware />
          <Volume />
          <Brightness />
          <Network />
          <Tray />
          <Battery />
          <Clock />
        </box>
      </centerbox>
    </window>
  )
}