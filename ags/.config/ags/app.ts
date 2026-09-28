import { Astal, Gtk, Gdk } from "ags/gtk4"
import style from "./style.scss"
import { Bar } from "./widget/Bar"
import { OSD } from "./widget/OSD"
import { audioPopup, networkPopup, bluetoothPopup, displayPopup, powerPopup, sysMenuPopup, launcherPopup } from "./widget/panels/Popups"

const app = new Astal.Application({
    instanceName: "ags"
});

// A associação em Astal (GObject) via CamelCase direto e não via construtor evita check restrito de type no GObject.
app.requestHandler = (request: string, res: (msg: string) => void) => {
    const args = request.split(" ");
    const cmd = args[0];
    const action = args[1];

    if (cmd === "toggle" && action) {
        const win = app.get_windows().find(w => w.name === action);
        if (win) {
            win.visible = !win.visible;
            res("ok");
            return;
        }
        res("error");
        return;
    }

    if (cmd === "close-all") {
        const windows = app.get_windows();
        windows.forEach(win => {
            if (win.name !== "bar" && win.name !== "osd") {
                win.visible = false;
            }
        });
        res("ok");
        return;
    }

    res("error");
};

app.connect("activate", () => {
    // Carrega o CSS via GTK4 nativo
    const provider = new Gtk.CssProvider();
    provider.load_from_path(style);
    Gtk.StyleContext.add_provider_for_display(Gdk.Display.get_default()!, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

    const monitors = app.get_monitors();
    if (monitors[0]) {
        Bar(monitors[0]);
    }

    audioPopup();
    networkPopup();
    bluetoothPopup();
    displayPopup();
    powerPopup();
    sysMenuPopup();
    launcherPopup();

    OSD();
});

app.run();