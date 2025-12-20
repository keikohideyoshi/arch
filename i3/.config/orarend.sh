#!/bin/bash

# -----------------------------------
#          KONFIGURÁCIÓ
# -----------------------------------

# 1. A START_DATE egy "A" hét egy tetszőleges napja.
#    FONTOS: Ezt állítsd be a tanév első "A" hetének tényleges kezdő dátumára (YYYY-MM-DD).
START_DATE="2025-09-01" 

# 2. PETI ÓRARENDJE (A Te beállításaidat tartalmazza)
#    A kulcsok angolul vannak (Monday...Friday) a dátumparancsok egyszerű kezelése miatt.

# A HÉT ÓRAREND
declare -A A_HET
A_HET[Monday]="
Nyelvtan
Irodalom
Tesi
Matematika
Technika"
A_HET[Tuesday]="
Tesi
Matematika
Angol
Rajz
Ének"
A_HET[Wednesday]="
Irodalom
Nyelvtan
Matematika
Info
Tesi"
A_HET[Thursday]="
Tesi
Rajz
Környezet
Ének
Etika"
A_HET[Friday]="
Nyelvtan
Irodalom
Tesi
Matematika"

# B HÉT ÓRAREND
declare -A B_HET
B_HET[Monday]="
Matematika
Tesi
Angol
Ének"
B_HET[Tuesday]="
Irodalom
Nyelvtan
Tesi
Matematika
Rajz"
B_HET[Wednesday]="
Tesi
Matematika
Technika
Ének
Nyelvtan"
B_HET[Thursday]="
Nyelvtan
Irodalom
Környezet
Tesi
Etika"
B_HET[Friday]="
Tesi
Matematika
Rajz
Info
Irodalom"


# -----------------------------------
#             LOGIKA
# -----------------------------------

SECONDS_IN_WEEK=604800 # 7 nap * 24 óra * 60 perc * 60 másodperc

# 1. Cél nap és dátum meghatározása a futtatás napja alapján
TODAY_DAY_EN=$(LC_ALL=C date +%A)
TARGET_DATE_STRING=""
OUTPUT_PREFIX=""

if [ "$TODAY_DAY_EN" == "Friday" ] || [ "$TODAY_DAY_EN" == "Saturday" ] || [ "$TODAY_DAY_EN" == "Sunday" ]; then
    # Ha ma Péntek, Szombat vagy Vasárnap van, a cél a következő Hétfő.
    TARGET_DATE_STRING="next Monday"
    OUTPUT_PREFIX="órái hétfőn"
else
    # Ha ma Hétfő, Kedd, Szerda vagy Csütörtök van, a cél a holnapi nap.
    TARGET_DATE_STRING="tomorrow"
    OUTPUT_PREFIX="órái holnap"
fi

# 2. Cél nap adatainak lekérése
TARGET_DAY_EN=$(LC_ALL=C date -d "$TARGET_DATE_STRING" +%A)
TARGET_DATE_SECONDS=$(date -d "$TARGET_DATE_STRING" +%s)

# 3. Magyar napnév meghatározása
TARGET_DAY_HU=""
case "$TARGET_DAY_EN" in
    Monday) TARGET_DAY_HU="Hétfő" ;;
    Tuesday) TARGET_DAY_HU="Kedd" ;;
    Wednesday) TARGET_DAY_HU="Szerda" ;;
    Thursday) TARGET_DAY_HU="Csütörtök" ;;
    Friday) TARGET_DAY_HU="Péntek" ;;
    Saturday) TARGET_DAY_HU="Szombat" ;;
    Sunday) TARGET_DAY_HU="Vasárnap" ;;
esac

# 4. Hétvége ellenőrzése
# Ez csak a BIZTONSÁG miatt marad bent, ha a "next Monday" valamiért hibás dátumot adna.
if [ "$TARGET_DAY_EN" == "Saturday" ] || [ "$TARGET_DAY_EN" == "Sunday" ]; then
    echo "
Peti holnap ($TARGET_DAY_HU) nem megy iskolába."
    exit 0
fi

# 5. A/B Hét meghatározása a CÉL napra vonatkozóan
START_SECONDS=$(date -d "$START_DATE" +%s)
ELAPSED_SECONDS=$((TARGET_DATE_SECONDS - START_SECONDS))
ELAPSED_WEEKS=$((ELAPSED_SECONDS / SECONDS_IN_WEEK))

REMAINDER=$((ELAPSED_WEEKS % 2))

if [ "$REMAINDER" -eq 0 ]; then
    # Páros hetek (0, 2, 4...) -> "A" hét
    TARGET_WEEK_TYPE="'A'"
    SCHEDULE=${A_HET[$TARGET_DAY_EN]}
else
    # Páratlan hetek (1, 3, 5...) -> "B" hét
    TARGET_WEEK_TYPE="'B'"
    SCHEDULE=${B_HET[$TARGET_DAY_EN]}
fi

# 6. Végleges kimenet
# A kimeneti üzenet a futtatás napja alapján változik (holnap vagy hétfő).
WEEK_INFO="$TARGET_WEEK_TYPE HÉT ($TARGET_DAY_HU)"

if [ -z "$SCHEDULE" ]; then
    # Ez csak akkor fut le, ha hiba van az órarend beállításában
    echo "Hiba: Nincs órarend beállítva a $WEEK_INFO napra."
else
    # A kimenet a Conky-hoz
    echo "$OUTPUT_PREFIX ($TARGET_WEEK_TYPE hét):
$SCHEDULE"
fi
