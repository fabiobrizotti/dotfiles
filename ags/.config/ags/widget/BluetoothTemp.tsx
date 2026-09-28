import { Astal, Gtk } from "ags/gtk4"
import GLib from "gi://GLib"

function getBtIcon(): string {
    try {
        const [success, stdout] = GLib.spawn_command_line_sync("bluetoothctl show")
        if (success && stdout) {
            const text = new TextDecoder().decode(stdout)
            return text.includes("Powered: yes") ? "󰂯" : "󰂲"
        }
    } catch {}
    return "󰂲"
}

export function BluetoothTemp() {
    return (
        <box class="bluetooth-container">
            <button
                class="bluetooth-icon"
                onClicked={() => {
                    const app = Astal.Application.get_default()
                    const win = app.get_windows().find(w => w.name === "bluetooth")
                    if (win) win.visible = !win.visible
                }}
                setup={(self) => {
                    const label = self.get_child() as Gtk.Label
                    GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 3, () => {
                        if (label) label.set_label(getBtIcon())
                        return GLib.SOURCE_CONTINUE
                    })

                    const gesture = new Gtk.GestureClick()
                    gesture.set_button(3)
                    gesture.connect("pressed", () => {
                        try {
                            const isOff = getBtIcon() === "󰂲"
                            GLib.spawn_command_line_async(`bluetoothctl power ${isOff ? "on" : "off"}`)
                            if (label) label.set_label(isOff ? "󰂯" : "󰂲")
                        } catch {}
                    })
                    self.add_controller(gesture)
                }}
            >
                <label label={getBtIcon()} />
            </button>
        </box>
    )
}