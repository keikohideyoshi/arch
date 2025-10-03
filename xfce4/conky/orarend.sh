#!/bin/bash

# -----------------------------------
#          KONFIGURÁCIÓ
# -----------------------------------

# 1. A START_DATE egy "A" hét egy tetszőleges napja.
#    FONTOS: Ezt állítsd be a tanév első "A" hetének tényleges kezdő dátumára (YYYY-MM-DD).
START_DATE="2025-09-01" 

# 2. PETI ÓRARENDJE (MÓDOSÍTSD A SAJÁT ÓRAREND SZERINT!)
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

# 1. Holnapi nap meghatározása (angol és magyar néven)
TOMORROW_DAY_EN=$(LC_ALL=C date -d "tomorrow" +%A)
TOMORROW_DAY_HU=""

case "$TOMORROW_DAY_EN" in
    Saturday) TOMORROW_DAY_HU="Szombat" ;;
    Sunday) TOMORROW_DAY_HU="Vasárnap" ;;
    Monday) TOMORROW_DAY_HU="Hétfő" ;;
    Tuesday) TOMORROW_DAY_HU="Kedd" ;;
    Wednesday) TOMORROW_DAY_HU="Szerda" ;;
    Thursday) TOMORROW_DAY_HU="Csütörtök" ;;
    Friday) TOMORROW_DAY_HU="Péntek" ;;
esac

# 2. Hétvége ellenőrzése
if [ "$TOMORROW_DAY_EN" == "Saturday" ] || [ "$TOMORROW_DAY_EN" == "Sunday" ]; then
    echo "
Peti holnap ($TOMORROW_DAY_HU) nem megy iskolába."
    exit 0
fi

# 3. A/B Hét meghatározása a holnapi napra vonatkozóan
TOMORROW_SECONDS=$(date -d "tomorrow" +%s)
START_SECONDS=$(date -d "$START_DATE" +%s)

# Eltelt hetek száma a kezdő dátumtól HOLNAPIG. Ez kezeli a váltást.
ELAPSED_SECONDS=$((TOMORROW_SECONDS - START_SECONDS))
ELAPSED_WEEKS=$((ELAPSED_SECONDS / SECONDS_IN_WEEK))

REMAINDER=$((ELAPSED_WEEKS % 2))

if [ "$REMAINDER" -eq 0 ]; then
    # Páros hetek (0, 2, 4...) -> "A" hét
    TARGET_WEEK_TYPE="A"
    SCHEDULE=${A_HET[$TOMORROW_DAY_EN]}
else
    # Páratlan hetek (1, 3, 5...) -> "B" hét
    TARGET_WEEK_TYPE="B"
    SCHEDULE=${B_HET[$TOMORROW_DAY_EN]}
fi

# 4. Végleges kimenet
WEEK_INFO="$TARGET_WEEK_TYPE HÉT ($TOMORROW_DAY_HU)"

if [ -z "$SCHEDULE" ]; then
    # Ez csak akkor fut le, ha hiba van az órarend beállításában
    echo "Hiba: Nincs órarend beállítva a $WEEK_INFO napra."
else
    # A kimenet a Conky-hoz
    echo "$SCHEDULE"
fi
