import { createBinding } from "ags"
import { Gtk } from "ags/gtk4"
import Hyprland from "gi://AstalHyprland"

export function Workspaces() {
    const hypr = Hyprland.get_default()
    const workspaces = [1, 2, 3, 4, 5]

    return <box class="workspaces">
        {workspaces.map(id => (
            <button
                class={createBinding(hypr, "focusedWorkspace").as(fw => fw.id === id ? "workspace active" : "workspace")}
                onClicked={() => hypr.dispatch("workspace", id.toString())}
            >
                <label label={id.toString()} />
            </button>
        ))}
    </box>
}