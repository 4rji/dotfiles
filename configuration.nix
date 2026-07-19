{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./vm.nix
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

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

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  services.resolved.enable = true;
  services.printing.enable = true;


  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  users.users.nala = {
    isNormalUser = true;
    description = "nala";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      cryptomator
      gcc
      rpi-imager
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
      lsd
      tldr
      kde-gtk-config
      sublime
      iproute2
      moreutils
      google-chrome
      pipx
      virtualenv
      distrobox
      opera
      brave
      lazygit
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
      zsh
      # thunderbird
    ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  boot.extraModulePackages = [
    config.boot.kernelPackages.rtl8814au
  ];

  environment.systemPackages = with pkgs; [
    bolt
    # Agrega otros paquetes aquí si lo deseas
  ];


#ollama
  services.ollama.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      GatewayPorts = "yes";
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      X11UseLocalhost = false;
      AllowTcpForwarding = true;
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.zsh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 2222 ];
  networking.firewall.enable = true;

  system.stateVersion = "24.05";




  environment.etc."proxychains.conf".text = ''
    # Configuración personalizada de Proxychains
    dynamic_chain
    proxy_dns
    remote_dns_subnet 224
    tcp_read_time_out 15000
    tcp_connect_time_out 8000

    [ProxyList]
    # Añade tus proxies aquí
    socks5  192.168.141.90 1080
#    socks5  192.168.140.135 1080
  '';




}
