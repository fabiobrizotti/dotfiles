import { createPoll } from "ags/time"
import { execAsync } from "ags/process"

const DAYS = [
  "seg",
  "ter",
  "qua",
  "qui",
  "sex",
  "sáb",
  "dom",
]
const DAYS_OFFSET = 1

async function dateLabel() {
  const out = await execAsync(`date +"%u %d/%m"`)
  const [w, ddmm] = out.trim().split(/\s+/)
  const day = DAYS[(Number(w) - DAYS_OFFSET) % DAYS.length]
  return `${day}, ${ddmm}`
}

export function Clock() {
  const time = createPoll("", 1000, () =>
    execAsync('date +"%H:%M"'),
  )
  const date = createPoll("", 60000, dateLabel)

  return (
    <box class="clock" spacing={6}>
      <label class="time" label={time} />
      <label class="sep" label="•" />
      <label class="date" label={date} />
    </box>
  )
}