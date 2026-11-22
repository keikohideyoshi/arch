#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODE="full"; DRY=0; WITH_AUR=0; ASSUME_YES=0
for arg in "$@"; do
 case "$arg" in
  full|desktop|apps) MODE="$arg" ;;
  --dry-run) DRY=1 ;;
  --with-aur) WITH_AUR=1 ;;
  --yes) ASSUME_YES=1 ;;
  -h|--help) echo 'Használat: ./install.sh [full|desktop|apps] [--dry-run] [--with-aur] [--yes]'; exit 0 ;;
  *) echo "Ismeretlen argumentum: $arg" >&2; exit 2 ;;
 esac
done
[[ $EUID -ne 0 ]] || { echo 'Normál felhasználóként indítsd, ne sudo-val!' >&2; exit 1; }
command -v pacman >/dev/null || { echo 'Arch/EndeavourOS szükséges.' >&2; exit 1; }
[[ -f /etc/os-release ]] && . /etc/os-release
[[ "${ID:-}" == "endeavouros" || "${ID_LIKE:-}" == *arch* || "${ID:-}" == "arch" ]] || { echo 'Figyelem: ez a telepítő Arch/EndeavourOS rendszerre készült.' >&2; exit 1; }
LOGDIR="$HOME/.local/state/keiko-installer"; mkdir -p "$LOGDIR"
LOG="$LOGDIR/install-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1
info(){ printf '\n[INFO] %s\n' "$*"; }
warn(){ printf '[FIGYELMEZTETÉS] %s\n' "$*" >&2; }
run(){ if ((DRY)); then printf '[DRY]'; printf ' %q' "$@"; echo; else "$@"; fi; }
backup_dir="$HOME/.local/state/keiko-installer/backups/$(date +%Y%m%d-%H%M%S)"
info "Üzemmód: $MODE; napló: $LOG"
if (( ! ASSUME_YES && ! DRY )); then
 read -r -p 'Indulhat a telepítés? [i/N] ' reply
 [[ "$reply" == [iIyY]* ]] || exit 0
fi
install_repo(){
 info 'Csomagadatbázis frissítése és elérhető csomagok telepítése'
 run sudo pacman -Syu --noconfirm || { warn 'A rendszerfrissítés sikertelen; csomagtelepítés kihagyva.'; return 1; }
 local -a available=() missing=() installed=()
 local pkg
 while IFS= read -r pkg; do
  [[ -z "$pkg" || "$pkg" == \#* ]] && continue
  if pacman -Qq "$pkg" >/dev/null 2>&1; then installed+=("$pkg")
  elif pacman -Si "$pkg" >/dev/null 2>&1; then available+=("$pkg")
  else missing+=("$pkg"); fi
 done < "$ROOT/packages/repo-explicit.txt"
 info "Már telepítve: ${#installed[@]}; telepítendő: ${#available[@]}; nem elérhető: ${#missing[@]}"
 if ((${#missing[@]})); then printf '%s\n' "${missing[@]}" | tee "$LOGDIR/repo-missing.txt"; fi
 if ((${#available[@]})); then
  if ((DRY)); then printf '[DRY] sudo pacman -S --needed --noconfirm (%s csomag)\n' "${#available[@]}";
  else
   local batch_size=20 i
   for ((i=0;i<${#available[@]};i+=batch_size)); do
    if ! sudo pacman -S --needed --noconfirm "${available[@]:i:batch_size}"; then
     warn 'Egy csomagcsoport telepítése sikertelen, egyenként próbálkozom.'
     local item
     for item in "${available[@]:i:batch_size}"; do sudo pacman -S --needed --noconfirm "$item" || warn "Nem települt: $item"; done
    fi
   done
  fi
 fi
}
install_yay(){
 if command -v yay >/dev/null; then return 0; fi
 info 'yay telepítése felhasználói környezetben'
 if ((DRY)); then info '[DRY] yay AUR build'; return 0; fi
 sudo pacman -S --needed --noconfirm git base-devel || return 1
 local tmp; tmp="$(mktemp -d)"
 if git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp/yay"; then
  (cd "$tmp/yay" && makepkg -si --noconfirm) || { rm -rf "$tmp"; return 1; }
 else rm -rf "$tmp"; return 1; fi
 rm -rf "$tmp"
}
install_aur(){
 ((WITH_AUR)) || { info 'AUR komponensek kihagyva (kapcsoló: --with-aur)'; return 0; }
 install_yay || { warn 'yay nem települt; AUR kihagyva.'; return 0; }
 local pkg
 while IFS= read -r pkg; do
  [[ -z "$pkg" || "$pkg" == \#* ]] && continue
  if pacman -Qq "$pkg" >/dev/null 2>&1; then info "Már telepítve: $pkg"; continue; fi
  if ((DRY)); then info "[DRY] yay -S --needed $pkg";
  else
   info "AUR telepítés: $pkg (PKGBUILD és források ellenőrzése ajánlott)"
   yay -S --needed "$pkg" || warn "AUR telepítés sikertelen: $pkg"
  fi
 done < "$ROOT/packages/aur-optional.txt"
}
copy_desktop(){
 info 'Dotfile-ok, szkriptek és háttérképek visszaállítása'
 local source="$ROOT/payload/home" dest="$HOME" rel target
 while IFS= read -r -d '' file; do
  rel="${file#"$source"/}"; target="$dest/$rel"
  if [[ -e "$target" || -L "$target" ]]; then
   if cmp -s "$file" "$target"; then continue; fi
   run mkdir -p "$backup_dir/$(dirname "$rel")"
   run cp -a "$target" "$backup_dir/$rel"
  fi
  run mkdir -p "$(dirname "$target")"
  run install -m "$(stat -c '%a' "$file")" "$file" "$target"
 done < <(find "$source" -type f -print0)
 info "Biztonsági mentések: $backup_dir (csak ha volt felülírt fájl)"
 info 'Az órarend és az A/B hét eredeti tartalma változatlan.'
 if [[ ! -f "$HOME/.config/keiko-installer/weather.env" ]]; then
  run mkdir -p "$HOME/.config/keiko-installer"
  run install -m 600 "$ROOT/config/weather.env.example" "$HOME/.config/keiko-installer/weather.env"
 fi
 if [[ ! -f "$HOME/.cache/weather.txt" ]]; then run mkdir -p "$HOME/.cache"; fi
}
services(){
 info 'Alapvető szolgáltatások engedélyezése'
 local unit
 for unit in NetworkManager.service lightdm.service firewalld.service power-profiles-daemon.service systemd-timesyncd.service fstrim.timer; do
  if systemctl list-unit-files "$unit" --no-legend 2>/dev/null | grep -q "^$unit "; then
   run sudo systemctl enable "$unit" || warn "Nem sikerült engedélyezni: $unit"
  else warn "Nem érhető el: $unit"; fi
 done
 if pacman -Qq cisco-secure-client >/dev/null 2>&1 && systemctl list-unit-files vpnagentd.service --no-legend 2>/dev/null | grep -q '^vpnagentd.service '; then
  run sudo systemctl enable vpnagentd.service || true
 fi
}
case "$MODE" in
 full) install_repo || true; copy_desktop; install_aur; services ;;
 desktop) copy_desktop ;;
 apps) install_repo || true; install_aur ;;
esac
info 'Befejezve. A konfigurációk aktiválásához jelentkezz ki és vissza (vagy indítsd újra a gépet).'
info "Napló: $LOG"
