# Keiko EndeavourOS Installer 1.0

Személyre szabott, **frissen telepített EndeavourOS/Arch + i3wm** rendszer visszaállításához. A ZIP tartalmazza a felhasználói konfigurációkat, négy szkriptet és a két eredeti háttérképet. A TF fejlesztési projektek **nincsenek benne**.

## Indítás

```bash
unzip keiko-endeavouros-installer-1.0.zip
cd keiko-endeavouros-installer
chmod +x install.sh
./install.sh full --dry-run
./install.sh full
```

Üzemmódok:
- `full`: csomagok, desktop konfigurációk, háttérképek, rendszer-szolgáltatások
- `desktop`: kizárólag a felhasználói konfigurációk, szkriptek és háttérképek
- `apps`: csak csomagtelepítés

Kapcsolók:
- `--dry-run`: tervezett fájlváltoztatások és csomagtelepítés megtekintése; **nem változtat** a rendszeren
- `--with-aur`: Cisco Secure Client és VMware Horizon Client telepítési kísérlete `yay`-jel (alapértelmezésben ki)
- `--yes`: induláskori megerősítés kihagyása (nem hagyja jóvá automatikusan az AUR minden interakcióját)

Példa: `./install.sh full --with-aur`

**Ne futtasd `sudo ./install.sh` paranccsal!** A script a szükséges műveletekhez maga használ `sudo`-t.

## Külön figyelmet igényel

1. **OpenWeather kulcs:** az eredeti szkriptben szereplő API-kulcsot a kiadott csomagból eltávolítottuk. A kulcsot cseréld le a szolgáltatónál, és írd be a `~/.config/keiko-installer/weather.env` fájlba `OPENWEATHER_API_KEY="..."` formában; jogosultsága `600`. Az időjáráslekérés HTTPS-t használ. Kulcs nélkül az időjárás-szkript csendben kilép.
2. **A/B hét és órarend:** az eredeti `2025-09-01` kezdődátumot és órarendet érintetlenül hagytuk. A dátumszámítás nyári/téli óraátállításkor eltérhet; a felhasználó később tervezi átalakítani.
3. **Monitorok:** az eredeti DVI-D-1/HDMI-1 monitorbeállítást egy óvatos, csatlakoztatott kijelzőkre támaszkodó szkript helyettesíti. Két kijelzőnél a régi kiosztást igyekszik követni; ellenőrizd az első indítás után.
4. **Rofi:** a korábban hivatkozott, de nem mentett `arc_dark_transparent_colors.rasi` helyett egy csomagolt, sötét helyettesítő téma kerül be.
5. **AUR:** a két vállalati kliens telepítése nem garantálható (AUR PKGBUILD, licenc, letöltési forrás és csomagverzió változhat). Az AUR build szkripteket ellenőrizd telepítés előtt. VPN bejelentkezési adatok és profilok nincsenek a csomagban.
6. **Csomagok:** a korábban explicit telepített csomagok listája a `packages/repo-explicit.txt` fájlban található, a két foreign csomag nélkül. A script kihagyja a már telepítetteket és a jelenlegi tárolóban nem elérhetőket, de egy régi csomag helyettesítéséről nem dönt automatikusan. A teljes csomaglista nem kerül vakon telepítésre.
7. **Grafikus bejelentkezés:** LightDM engedélyezés történik, de az i3 munkamenet kiválasztását és a monitorokat az első bejelentkezéskor ellenőrizd.
8. **Adatok:** nincs benne böngészőprofil, VPN-hitelesítés, gépazonosító, Wi-Fi-jelszó, SSH-kulcs vagy TF projekt. A rendszerpartíciót és partíciós sémát nem állítja vissza.
9. **Személyes fájlok:** a csomag a dotfile-mentés teljes tartalmát visszaállítja, így a Thunar könyvjelzői és felhasználói útvonalak egy része a korábbi felhasználónévre utalhat.

## Napló és mentés

- Napló: `~/.local/state/keiko-installer/install-YYYYMMDD-HHMMSS.log`
- Felülírt fájlok mentése: `~/.local/state/keiko-installer/backups/` alatt
- Nem elérhető csomagok: `~/.local/state/keiko-installer/repo-missing.txt`
- Újrafuttatható: a változatlan fájlokat kihagyja, a csomagokat `--needed`-del telepíti.

## Korlátok

Az első kiadás **nem teljes lemezkép és nem automatikus OS-telepítő**. Friss EndeavourOS telepítése után kell futtatni, élő internetkapcsolattal. A `--dry-run` nem vizsgálja meg az AUR csomagok tényleges buildelhetőségét. Egyes grafikus témák, illesztőprogramok, monitorbeállítások és külső csomagok manuális ellenőrzést igényelhetnek.
