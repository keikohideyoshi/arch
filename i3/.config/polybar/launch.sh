#!/bin/bash

sleep 2

# Futó folyamatok leállítása
killall -q polybar

# Várakozás a leállásig
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Monitorok detektálása és Polybar indítása mindegyikre
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
  done
else
  polybar --reload example &
fi

echo "Polybar launched on all monitors..."
