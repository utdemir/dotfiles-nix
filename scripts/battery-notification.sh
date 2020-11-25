#!/usr/bin/env sh

LOW_THRESHOLD=10
CRIT_THRESHOLD=3

is_charging=$(cat /sys/class/power_supply/AC/online)

energy_full=$(cat /sys/class/power_supply/BAT*/energy_full | awk '{s+=$1} END {print s}'   )
energy_now=$(cat /sys/class/power_supply/BAT*/energy_now | awk '{s+=$1} END {print s}'   )

perc=$(( energy_now * 100 / energy_full ))

if [[ -z "$perc" ]]; then exit 1
elif [[ "$perc" -lt "$CRIT_THRESHOLD" ]]; then notify-send -u critical "Battery is critical! ($perc%)"
elif [[ "$perc" -lt "$LOW_THRESHOLD" ]]; then notify-send -u normal "Battery is low! ($perc%)"
fi

