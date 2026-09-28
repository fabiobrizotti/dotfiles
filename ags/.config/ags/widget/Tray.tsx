import { createBinding, For, onCleanup } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import AstalTray from "gi://AstalTray?version=0.1"

export function Tray() {
  const tray = AstalTray.get_default()
  const items = createBinding(tray, "items").as((its) =>
    its.filter((i) => i.id !== null),
  )

  return (
    <box class="tray" spacing={6}>
      <For each={items}>
        {(item) => {
          let popover: Gtk.Popover

          return (
            <box
              class="tray-item"
              css={`
                padding: 0 2px;
              `}
            >
              <image
                gicon={createBinding(item, "gicon")}
                tooltipMarkup={item.tooltipMarkup || item.title}
                pixelSize={16}
              />
              <Gtk.GestureClick
                onPressed={(ctrl, _count, x, y) => {
                  const button = ctrl.get_current_button()
                  if (button === Gdk.BUTTON_PRIMARY) {
                    item.activate(x, y)
                  } else if (button === Gdk.BUTTON_SECONDARY) {
                    if (popover) {
                      popover.visible ? popover.popdown() : popover.popup()
                    }
                  } else {
                    item.secondary_activate(x, y)
                  }
                }}
                button={0}
              />
              <Gtk.Popover
                menuModel={item.menuModel}
                $={(self) => {
                  popover = self
                  self.insert_action_group("dbusmenu", item.actionGroup)
                  const hid = item.connect("notify::action-group", () =>
                    self.insert_action_group("dbusmenu", item.actionGroup),
                  )
                  onCleanup(() => item.disconnect(hid))
                }}
              />
            </box>
          )
        }}
      </For>
    </box>
  )
}