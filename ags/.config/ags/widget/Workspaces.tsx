import { Astal, Gtk } from "ags/gtk4"
import { For, createBinding, createComputed } from "ags"
import AstalHyprland from "gi://AstalHyprland"

const ROMAN = ["ⅰ", "ⅱ", "ⅲ", "ⅳ", "ⅴ", "ⅵ", "ⅶ", "ⅷ", "ⅸ", "ⅹ"]
const WS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

export function Workspaces() {
  const hypr = AstalHyprland.get_default()
  const focused = createBinding(hypr, "focused-workspace")
  const workspaces = createBinding(hypr, "workspaces")

  return (
    <box class="workspaces" spacing={4}>
      <For each={createComputed(() => WS)}>
        {(id: number) => {
          const active = createComputed(() => focused.get()?.id === id)
          const occupied = createComputed(
            () => workspaces.get().some((w) => w.id === id),
          )
          const cls = createComputed(() => {
            let c = "ws"
            if (active.get()) c += " active"
            if (occupied.get()) c += " occupied"
            return c
          })

          return (
            <button
              class={cls}
              label={ROMAN[id - 1]}
              tooltipText={`Workspace ${id}`}
              onClicked={() => hypr.dispatch("workspace", String(id))}
            />
          )
        }}
      </For>
    </box>
  )
}