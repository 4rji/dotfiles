{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./vm.nix
      ./services.nix
      ./paquetes.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "xps";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 2222 ];

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS         = "en_US.UTF-8";
    LC_IDENTIFICATION  = "en_US.UTF-8";
    LC_MEASUREMENT     = "en_US.UTF-8";
    LC_MONETARY        = "en_US.UTF-8";
    LC_NAME            = "en_US.UTF-8";
    LC_NUMERIC         = "en_US.UTF-8";
    LC_PAPER           = "en_US.UTF-8";
    LC_TELEPHONE       = "en_US.UTF-8";
    LC_TIME            = "en_US.UTF-8";
  };

  users.users.natasha = {
    isNormalUser = true;
    description = "natasha";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
   };

  services.gvfs.enable = true;
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ fuse ];
  programs.zsh.enable = true;
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

#  services.xserver.enable = true;
 # services.displayManager.sddm.enable = true;

  services.displayManager.sddm.wayland.enable = true;

}
