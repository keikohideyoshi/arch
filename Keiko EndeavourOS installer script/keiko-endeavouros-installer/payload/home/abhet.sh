#!/bin/bash

# A Szeptember első hete, ami "A" hét volt, egy tetszőleges napja.
# Ezt kell beállítanod a tényleges "A" hét kezdő napjára (pl. Szept. 1. vagy 2.).
# A dátum formátuma YYYY-MM-DD
START_DATE="2025-09-01" # Példa: feltételezzük, hogy 2024. szeptember 2. egy "A" hét hétfője volt.

# Aktuális dátum (másodpercek az epoch óta)
NOW_SECONDS=$(date +%s)

# Kezdő dátum (másodpercek az epoch óta)
# Megjegyzés: a '-d' opció GNU-specifikus.
START_SECONDS=$(date -d "$START_DATE" +%s)

# Kiszámoljuk az eltelt időt másodpercekben
ELAPSED_SECONDS=$((NOW_SECONDS - START_SECONDS))

# Egy hét 604800 másodperc (7 nap * 24 óra * 60 perc * 60 másodperc)
SECONDS_IN_WEEK=604800

# Kiszámoljuk az eltelt hetek számát (a kezdő héttől számítva)
# Az első hét, ami az "A" hét volt, a 0. hétnek számít a számítás szempontjából.
# A kerekítés lefelé történik, így a hét minden napján ugyanaz az eredmény.
ELAPSED_WEEKS=$((ELAPSED_SECONDS / SECONDS_IN_WEEK))

# Az A/B váltakozás meghatározása
# Ha az eltelt hetek száma páros (0, 2, 4...), akkor "A" hét van (A hét volt a 0. hét).
# Ha páratlan (1, 3, 5...), akkor "B" hét van.
# A modulo operátorral ( % 2 ) ellenőrizzük a paritást.
REMAINDER=$((ELAPSED_WEEKS % 2))

if [ "$REMAINDER" -eq 0 ]; then
    echo "Petinek 'A' hét van."
else
    echo "Petinek 'B' hét van."
fi
