# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vm.nix
      #./font.nix
    ];






  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "xps"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };



  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
#hyperland
programs.hyprland = {
	enable = true;
	xwayland.enable = true;
};



#  # Configure keymap in X11
 # services.xserver = {
  #  layout = "us";
#    xkbVariant = "";
 # };

 networking.networkmanager.enable = true;


# I think for Wireguard
#services.resolved.enable = true;


  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.natasha = {
    isNormalUser = true;
    description = "natasha";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [



hyprshot
nerdfetch

rofi-wayland
waybar
hyprland
#fish
hyprpaper
swww
networkmanagerapplet
starship
ffmpeg
pyprland
grimblast
      arp-scan
ansible-navigator
vscode
fuse
      zsh
swaylock
      #cryptomator
      gcc
      rpi-imager
      stacer
      figlet
      lolcat
      joplin
      kitty
      tmux
      fzf
      github-desktop
      git
      wget
      python3
      wireguard-tools
      fail2ban
      protonvpn-gui
      bat
      dash
      lsd
      tldr
      kde-gtk-config
      sublime
      iproute2
      moreutils
      google-chrome
      pipx

      swaynotificationcenter

      virtualenv
      distrobox
      opera
      brave
      gparted
      xclip
      jq
      procps
      yazi
      lsof
      python312Packages.pip
      dig
      barrier
      findutils
      magic-wormhole
      unzip
      neovim
      flameshot
      powershell
      feh
      gh
      nmap
      proxychains-ng
	tree
    #  thunderbird

    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run:
	hardware.bluetooth.enable = true;
	services.blueman.enable = true;
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  wget
  ];
services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      X11Forwarding = true;
      GatewayPorts = "yes";
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      X11UseLocalhost = false;
      AllowTcpForwarding = true;
    };
  };

programs.nix-ld.enable = true;
programs.nix-ld.libraries = with pkgs; [ fuse ];


  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
 programs.zsh.enable = true;

 networking.firewall.enable = true;

 networking.firewall.allowedTCPPorts = [ 2222 ];

#  enable firewall
 # networking.firewall.enable = true;
  
#disable firewall
 # networking.firewall.enable = false;
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
