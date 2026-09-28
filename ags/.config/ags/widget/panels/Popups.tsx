import { Astal, Gtk } from "ags/gtk4"

// Popups that are attached to the Bar (top right, 32px below top)
function BarPopover({ name }: { name: string }) {
    return <window
        name={name}
        layer={Astal.Layer.TOP}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
        marginTop={32}
        visible={false}
        keymode={Astal.Keymode.ON_DEMAND}
    >
        <box class="popup-box">
            <label label={`[WIP] ${name.toUpperCase()}`} />
        </box>
    </window>
}

// Center Modal (For Launcher)
function LauncherModal() {
    return <window
        name="launcher"
        layer={Astal.Layer.TOP}
        anchor={Astal.WindowAnchor.NONE}
        visible={false}
        keymode={Astal.Keymode.EXCLUSIVE}
    >
        <box class="launcher-box">
            <label label="[WIP] LAUNCHER" />
        </box>
    </window>
}

// Instances
export const audioPopup = () => BarPopover({ name: "audio" })
export const displayPopup = () => BarPopover({ name: "display" })
export const networkPopup = () => BarPopover({ name: "network" })
export const bluetoothPopup = () => BarPopover({ name: "bluetooth" })
export const powerPopup = () => BarPopover({ name: "power" })
export const sysMenuPopup = () => BarPopover({ name: "sys-menu" })
export const launcherPopup = () => LauncherModal()