import { Astal, Gtk } from "ags/gtk4"

export function OSD() {
    return <window
        name="osd"
        layer={Astal.Layer.OVERLAY}
        anchor={Astal.WindowAnchor.BOTTOM}
        marginBottom={64}
        visible={false}
    >
        <box class="osd-box">
            <label label="[WIP] OSD" />
        </box>
    </window>
}