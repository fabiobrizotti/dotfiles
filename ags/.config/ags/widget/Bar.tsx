import { Astal, Gtk, Gdk } from "ags/gtk4"
import { Workspaces } from "./Workspaces"
import { Clock } from "./Clock"
import { Mpris } from "./Mpris"
import { Tray } from "./Tray"
import { Network } from "./Network"
import { Volume } from "./Volume"
import { Brightness } from "./Brightness"
import { Battery } from "./Battery"
import { Notifications } from "./Notifications"
import { BluetoothTemp } from "./BluetoothTemp"

function SysMenu() {
    return <button
        class="sys-menu"
        onClicked={() => {
            const app = Astal.Application.get_default()
            const win = app.get_windows().find(w => w.name === "sys-menu")
            if (win) win.visible = !win.visible
        }}
    >
        <label label="" />
    </button>
}

export function Bar(monitor: Gdk.Monitor) {
    return <window
        name="bar"
        layer={Astal.Layer.TOP}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        monitor={monitor}
        marginTop={0}
        marginBottom={0}
    >
        <centerbox class="bar">
            {/* LEFT */}
            <box class="bar-left" halign={Gtk.Align.START}>
                <SysMenu />
                <Workspaces />
            </box>

            {/* CENTER */}
            <box class="bar-center" halign={Gtk.Align.CENTER}>
                <Clock />
                <Mpris />
            </box>

            {/* RIGHT */}
            <box class="bar-right" halign={Gtk.Align.END}>
                <Tray />
                <Network />
                <BluetoothTemp />
                <Volume />
                <Brightness />
                <Battery />
                <Notifications />
            </box>
        </centerbox>
    </window>
}