import { createPoll } from "ags/time"
import { execAsync } from "ags/process"

export function Clock() {
const time = createPoll("", 1000, () =>
  execAsync('date +"%H:%M"'),
)
const date = createPoll("", 60000, () =>
  execAsync('date +"%a %d %b"'),
)

  return (
    <box class="clock" spacing={6}>
      <label class="date" label={date} />
      <label class="time" label={time} />
    </box>
  )
}