import { property, register, Object as GObj } from "ags/gobject"
import { interval } from "ags/time"
import { readFileAsync } from "ags/file"
import { execAsync } from "ags/process"
import GLib from "gi://GLib"

const UPDATE_INTERVAL = 2000

@register({ GTypeName: "SystemMonitor" })
export default class SystemMonitor extends GObj {
  static instance: SystemMonitor

  static get_default() {
    if (!this.instance) this.instance = new SystemMonitor()
    return this.instance
  }

  @property(Number)
    cpuUsage = 0

  @property(Number)
    memUsage = 0

  @property(Number)
    temp = 0

  @property(Number)
    diskUsage = 0

  #timer: ReturnType<typeof interval> | null = null
  #lastCpu = { total: 0, idle: 0 }

  constructor() {
    super()
    this.refresh()
    this.#timer = interval(UPDATE_INTERVAL, () => this.refresh())
  }

  async refresh() {
    await Promise.all([
      this.#updateCpu(),
      this.#updateMem(),
      this.#updateTemp(),
      this.#updateDisk(),
    ])
  }

  async #updateCpu() {
    try {
      const stat = await readFileAsync("/proc/stat")
      const line = stat.split("\n").find((l) => l.startsWith("cpu "))
      if (!line) return
      const [, user, nice, system, idle] = line.split(/\s+/).map(Number)
      const total = user + nice + system + idle
      const totalDelta = total - this.#lastCpu.total
      const idleDelta = idle - this.#lastCpu.idle
      this.#lastCpu = { total, idle }
      if (totalDelta > 0) this.cpuUsage = 1 - idleDelta / totalDelta
    } catch (e) {
      console.warn("SystemMonitor: cpu poll failed", e)
    }
  }

  async #updateMem() {
    try {
      const info = await readFileAsync("/proc/meminfo")
      const g = (k: string) => {
        const m = info.match(new RegExp(`^${k}:\\s+(\\d+)`))
        return m ? Number(m[1]) : 0
      }
      const total = g("MemTotal")
      const available = g("MemAvailable")
      if (total > 0) this.memUsage = 1 - available / total
    } catch (e) {
      console.warn("SystemMonitor: mem poll failed", e)
    }
  }

  async #updateTemp() {
    const sources = ["4", "0"].filter((n) =>
      this.#fsExists(`${HWMON}/hwmon${n}/temp1_input`),
    )
    for (const n of sources) {
      try {
        const raw = await readFileAsync(`${HWMON}/hwmon${n}/temp1_input`)
        this.temp = Number(raw.trim()) / 1000
        return
      } catch {
        continue
      }
    }
    try {
      const raw = await readFileAsync("/sys/class/thermal/thermal_zone0/temp")
      this.temp = Number(raw.trim()) / 1000
    } catch (e) {
      console.warn("SystemMonitor: temp poll failed", e)
    }
  }

  #fsExists(path: string) {
    try {
      return !!GLib.file_test(path, GLib.FileTest.EXISTS)
    } catch {
      return false
    }
  }

  async #updateDisk() {
    try {
      const out = await execAsync(["df", "-P", "/"])
      const lines = out.trim().split("\n")
      const line = lines[lines.length - 1]
      const parts = line.trim().split(/\s+/)
      if (parts.length >= 5) {
        const used = Number(parts[2])
        const size = Number(parts[1])
        if (size > 0) this.diskUsage = used / size
      }
    } catch (e) {
      console.warn("SystemMonitor: disk poll failed", e)
    }
  }
}

const HWMON = "/sys/class/hwmon"