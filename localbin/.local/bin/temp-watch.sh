#!/usr/bin/env bash
# =============================================================================
# TEMP-WATCH — Monitora a temperatura da CPU e alerta via SwayNC
#
# Lê a temperatura do pacote (coretemp) e dispara notificação quando passa
# do limiar. Usa debounce por "subida de estado" + histerese para não spammer.
#
# Limiares (º):
#   ALERT = 85  → notificação normal
#   CRIT  = 90  → notificação crítica (teto de segurança)
#
# Uso:
#   temp-watch                 # executa em loop (usado no autostart do Hyprland)
#   temp-watch --once          # verifica uma vez e sai (diagnóstico)
# =============================================================================
set -uo pipefail

ALERT=85
CRIT=90
HYSTERESIS=3
INTERVAL=30
CHIP="coretemp-isa-0000"

state="normal"

read_temp() {
    sensors -u "$CHIP" 2>/dev/null | awk '
        /^Package id 0:/ { pkg=1 }
        pkg && /^  temp1_input:/ { print int($2); exit }
    '
}

notify() {
    local urgency="$1" icon="$2" title="$3" body="$4" temp="$5"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u "$urgency" -a "temp-watch" \
            -i "$icon" "$title" "$body"
    fi
    # fallback console para diagnóstico
    echo "[temp-watch] $(date +'%H:%M:%S') temp=${temp}C $title"
}

watch_loop() {
    while :; do
        local temp
        temp="$(read_temp)"
        if [[ -n "$temp" ]]; then
            if (( temp >= CRIT )) && [[ "$state" != "crit" ]]; then
                state="crit"
                notify critical dialog-warning \
                    "CPU CRÍTICA: ${temp}°C" \
                    "Ultrapassou o teto de segurança (${CRIT}°C). thermald/auto-cpufreq devem throttlar." \
                    "$temp"
            elif (( temp >= ALERT )) && [[ "$state" == "normal" ]]; then
                state="alert"
                notify normal dialog-information \
                    "CPU ALTA: ${temp}°C" \
                    "Acima de ${ALERT}°C — verifique a carga." \
                    "$temp"
            fi
            # histerese: só "esfria" volta ao normal depois de cair 3°C abaixo do limiar
            if (( temp < ALERT - HYSTERESIS )); then
                state="normal"
            fi
        fi
        sleep "$INTERVAL"
    done
}

case "${1:-}" in
    --once)
        t="$(read_temp)"
        echo "Package temp: ${t:-n/d}°C (alerta=${ALERT}, crítico=${CRIT})"
        ;;
    *) watch_loop ;;
esac
