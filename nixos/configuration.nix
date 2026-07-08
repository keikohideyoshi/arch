{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Budapest";

  i18n.defaultLocale = "hu_HU.UTF-8";

  services.xserver.enable = true;

  services.xserver.windowManager.i3.enable = true;

  services.displayManager.defaultSession = "none+i3";

  services.xserver.xkb = {
    layout = "hu";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  users.users.balazs = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  environment.systemPackages = with pkgs; [
    firefox
    git
    wget
    nano

    xterm
    dmenu
    i3status
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
