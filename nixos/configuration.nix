# NixOS Rendszer Konfiguráció - i3wm fókusszal

{ config, pkgs, ... }:

{
  # ===========================================================================
  # 1. ALAPVETŐ RENDSZERBEÁLLÍTÁSOK ÉS HARDVER
  # ===========================================================================

  imports = [ 
    ./hardware-configuration.nix 
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "25.11";

  fileSystems."/run/media/drszigetib/Keiko" = {
    device = "/dev/disk/by-uuid/c821f405-38f8-46d3-b092-89b8f451ff0a";
    fsType = "ext4";
    options = [ "nosuid" "nodev" "nofail" ];
  };

  # ===========================================================================
  # 2. HÁLÓZAT ÉS REGIONÁLIS BEÁLLÍTÁSOK
  # ===========================================================================

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "hu_HU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  console.keyMap = "hu";

  # ===========================================================================
  # 3. GRAFIKUS FELÜLET (X11 + i3wm)
  # ===========================================================================

  services.xserver = {
    enable = true;

    # Billentyűzet kiosztás
    xkb = {
      layout = "hu";
      variant = "";
    };

    # Display Manager (bejelentkező felület)
    displayManager.lightdm.enable = true;

    # i3 Ablakkezelő engedélyezése
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        rofi
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  # ===========================================================================
  # 4. HARDVERES SZOLGÁLTATÁSOK (HANG, NYOMTATÁS)
  # ===========================================================================

  services.printing.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ===========================================================================
  # 5. FELHASZNÁLÓK ÉS SZOFTVEREK
  # ===========================================================================

  nixpkgs.config.allowUnfree = true;

  users.users.drszigetib = {
    isNormalUser = true;
    description = "dr. Szigeti Balázs";
    extraGroups = [ "networkmanager" "wheel" ];
  };

 # Betűtípusok beállítása
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    # Az új szintaxis a 25.11-es és frissebb verziókhoz:
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  # Alapértelmezett böngésző
  programs.firefox.enable = true;

  # Thunar fájlkezelő és extra szolgáltatásai (pl. kuka, automatikus csatolás)
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true; # Szükséges a Thunar teljes funkcionalitásához (pl. hálózati meghajtók)
  services.tumbler.enable = true; # Kép-előnézetekhez a Thunarban

  # Rendszerszintű csomagok
  environment.systemPackages = with pkgs; [
    # Alapvető szerkesztők és eszközök
    gedit
    wget
    git
    chromium
    fastfetch
    btop
    dunst
    xcompmgr
    flameshot
    polkit_gnome
    xfce.xfce4-terminal
    kitty
    feh
    # LibreOffice friss változata
    libreoffice-fresh

    # Magyar helyesírás-ellenőrzéshez csak ezek kellenek:
    hunspell
    hunspellDicts.hu_HU
    hunspellDicts.en_US-large
      
    # Tömörítő és kicsomagoló eszközök
    zip        # .zip létrehozása
    unzip      # .zip kicsomagolása
    p7zip      # .7z és szinte minden más (nagyon erős eszköz)
    unrar      # .rar fájlokhoz (unfree csomag, de nálad engedélyezve van)
    gnutar     # A klasszikus .tar.gz, .tar.xz fájlokhoz
    bzip2      # .bz2 fájlokhoz
    gzip       # .gz fájlokhoz
    xz         # .xz fájlokhoz
    lz4        # Ultra gyors tömörítéshez
      ];
  # ===========================================================================
  # 6. EGYÉB SZOLGÁLTATÁSOK
  # ===========================================================================

  # Automatikus szemétgyűjtés beállítása
  nix.settings.auto-optimise-store = true; # Optimalizálja a fájlokat (hardlinkek)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  security.polkit.enable = true;
  
  # SSH és tűzfal (alapértelmezetten kikapcsolva/zárva)
  # services.openssh.enable = true;

  # Polkit ügynök automatikus indítása a háttérben
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
