{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vm.nix
    ./services.nix
    ./paquetes.nix
    ./display.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";

  #programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  #programs.ssh.askPassword = lib.mkForce "${pkgs.legacyPackages.x86_64-linux.gnome.seahorse}/libexec/seahorse/ssh-askpass";
  programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

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

  
#  programs.virt-manager.enable = true;
 # users.groups.libvirtd.members = ["natasha"];
 # virtualisation.libvirtd.enable = true;
 # virtualisation.spiceUSBRedirection.enable = true;
  services.blueman.enable = true; 
  hardware.bluetooth.enable = true;
  services.gvfs.enable = true;
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ fuse ];
  programs.zsh.enable = true;

  system.autoUpgrade.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


}
