#!/bin/bash

# A cél dátum (szenteste) hónapja és napja
TARGET_MONTH_DAY="12-24"
SECONDS_IN_DAY=86400 # Egy nap másodpercekben (24 * 60 * 60)

# 1. Cél dátum meghatározása (kezeli az év átlépését)
CURRENT_YEAR=$(date +%Y)
TARGET_DATE="$CURRENT_YEAR-$TARGET_MONTH_DAY"
TODAY_DATE=$(date +%Y-%m-%d)

# Ellenőrizzük, hogy az idei Karácsony már elmúlt-e
if [[ "$TODAY_DATE" > "$TARGET_DATE" ]]; then
    # Ha igen, a következő év december 24-e a cél
    NEXT_YEAR=$((CURRENT_YEAR + 1))
    TARGET_DATE="$NEXT_YEAR-$TARGET_MONTH_DAY"
fi

# 2. Időpontok másodpercekben (epoch)
# Kiszámoljuk a különbséget a CÉL dátum éjfél és a MAI dátum éjfél között.
# LC_ALL=C segít a date parancs szabványos működésében.
TARGET_SECONDS=$(LC_ALL=C date -d "$TARGET_DATE 00:00:00" +%s)
TODAY_SECONDS=$(LC_ALL=C date -d "today 00:00:00" +%s)

# 3. Különbség számítása és konvertálás napokra ("alvásokra")
DIFF_SECONDS=$((TARGET_SECONDS - TODAY_SECONDS))
DAYS_REMAINING=$((DIFF_SECONDS / SECONDS_IN_DAY))

# 4. Kimenet a Conky-hoz
if [ "$DAYS_REMAINING" -eq 0 ]; then
    echo "MA SZENTESTE VAN! 🎁"
elif [ "$DAYS_REMAINING" -eq 1 ]; then
    echo "Még 1 alvás! 🎅"
else
    echo "Szentestéig $DAYS_REMAINING alvás!"
fi
